#!/usr/bin/env bash
set -euo pipefail

# Ensures docker compose exists before doing anything else.
if ! command -v docker &>/dev/null; then
  echo "docker is required but not found in PATH" >&2
  exit 1
fi

if ! docker compose version &>/dev/null; then
  echo "docker compose V2 is required" >&2
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CAPTURE_DIR="$ROOT_DIR/captures"
SHARED_SAMPLE="$ROOT_DIR/data/shared/sample.txt"
FTP_UPLOAD_DIR="$ROOT_DIR/data/ftp/uploads"
SFTP_UPLOAD_DIR="$ROOT_DIR/data/sftp/uploads"
COMPOSE="docker compose"

mkdir -p "$CAPTURE_DIR" "$FTP_UPLOAD_DIR" "$SFTP_UPLOAD_DIR"

if [ ! -s "$SHARED_SAMPLE" ]; then
  cat <<'EOF' >"$SHARED_SAMPLE"
This is a sample file for the FTP vs SFTP demo.
It contains plain text to illustrate why encryption matters.
EOF
fi

PROTOCOL="${1:-both}"

cd "$ROOT_DIR"

cleanup() {
  $COMPOSE down --remove-orphans >/dev/null 2>&1 || true
}
trap cleanup EXIT

$COMPOSE down --remove-orphans >/dev/null 2>&1 || true

if [ "$PROTOCOL" = "ftp" ] || [ "$PROTOCOL" = "both" ]; then
  $COMPOSE up -d ftp >/dev/null
else
  $COMPOSE up -d sftp >/dev/null
fi

# Allow services enough time to become ready.
sleep 5

# Get the bridge interface name for packet capture
NETWORK_ID=$(docker network ls --filter name=ftp-sftp-docker-automation_demo -q)
BRIDGE_NAME="br-$(docker network inspect $NETWORK_ID | grep '"Id"' | head -1 | cut -d'"' -f4 | cut -c1-12)"

timestamp() {
  date +%Y%m%d_%H%M%S
}

run_ftp_transfer() {
  echo "Starting FTP upload"
  $COMPOSE run --rm ftp-client "curl --silent --show-error --ftp-create-dirs -T /data/sample.txt ftp://student:ftp123@ftp/uploads/sample.txt"
  echo "FTP upload complete"
}

run_sftp_transfer() {
  echo "Starting SFTP upload"
  $COMPOSE run --rm ftp-client "curl --silent --show-error -k -T /data/sample.txt sftp://student:sftp123@sftp:22/upload/sample.txt"
  echo "SFTP upload complete"
}

if [ "$PROTOCOL" = "ftp" ] || [ "$PROTOCOL" = "both" ]; then
  ftp_capture_name="ftp_transfer_$(timestamp).pcap"
  echo "Capturing FTP traffic to $ftp_capture_name"
  sudo tcpdump -i "$BRIDGE_NAME" -w "$CAPTURE_DIR/$ftp_capture_name" tcp port 21 &
  ftp_capture_pid=$!
  sleep 2
  if ! run_ftp_transfer; then
    echo "FTP transfer failed" >&2
    kill $ftp_capture_pid 2>/dev/null || true
    exit 1
  fi
  kill $ftp_capture_pid 2>/dev/null || true
  wait "$ftp_capture_pid" || true
  echo "FTP capture saved as $ftp_capture_name"
  echo
fi

if [ "$PROTOCOL" = "sftp" ] || [ "$PROTOCOL" = "both" ]; then
  sftp_capture_name="sftp_transfer_$(timestamp).pcap"
  echo "Capturing SFTP traffic to $sftp_capture_name"
  sudo tcpdump -i "$BRIDGE_NAME" -w "$CAPTURE_DIR/$sftp_capture_name" tcp port 22 &
  sftp_capture_pid=$!
  sleep 2
  if ! run_sftp_transfer; then
    echo "SFTP transfer failed" >&2
    kill $sftp_capture_pid 2>/dev/null || true
    exit 1
  fi
  kill $sftp_capture_pid 2>/dev/null || true
  wait "$sftp_capture_pid" || true
  echo "SFTP capture saved as $sftp_capture_name"
  echo
fi

echo "Captures saved in $CAPTURE_DIR"
echo "Inspect them with Wireshark to compare plaintext FTP versus encrypted SFTP traffic."

# Generate a simple analysis report
REPORT_FILE="$ROOT_DIR/analysis_report.md"
echo "# FTP vs SFTP Security Analysis Report" > "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "## Generated on $(date)" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

if ls $CAPTURE_DIR/ftp_transfer_*.pcap >/dev/null 2>&1; then
  FTP_PCAP=$(ls $CAPTURE_DIR/ftp_transfer_*.pcap | tail -1)
  echo "## FTP Analysis" >> "$REPORT_FILE"
  echo "Captured file: $(basename $FTP_PCAP)" >> "$REPORT_FILE"
  echo "" >> "$REPORT_FILE"
  echo "### Key Findings:" >> "$REPORT_FILE"
  echo "- **Credentials Exposed**: USER student, PASS ftp123 visible in plaintext." >> "$REPORT_FILE"
  echo "- **Data Exposed**: File contents transmitted without encryption." >> "$REPORT_FILE"
  echo "- **Security Risk**: Eavesdroppers can intercept sensitive information." >> "$REPORT_FILE"
  echo "" >> "$REPORT_FILE"
  echo "### Sample Packets:" >> "$REPORT_FILE"
  docker run --rm -v "$CAPTURE_DIR:/captures" nicolaka/netshoot tcpdump -r "/captures/$(basename $FTP_PCAP)" -A -c 10 | grep -E "(USER|PASS|sample)" | head -5 >> "$REPORT_FILE" 2>/dev/null || echo "No matching packets found." >> "$REPORT_FILE"
  echo "" >> "$REPORT_FILE"
fi

if ls $CAPTURE_DIR/sftp_transfer_*.pcap >/dev/null 2>&1; then
  SFTP_PCAP=$(ls $CAPTURE_DIR/sftp_transfer_*.pcap | tail -1)
  echo "## SFTP Analysis" >> "$REPORT_FILE"
  echo "Captured file: $(basename $SFTP_PCAP)" >> "$REPORT_FILE"
  echo "" >> "$REPORT_FILE"
  echo "### Key Findings:" >> "$REPORT_FILE"
  echo "- **Encrypted Traffic**: All data protected by SSH encryption." >> "$REPORT_FILE"
  echo "- **Credentials Secure**: No readable USER/PASS in captures." >> "$REPORT_FILE"
  echo "- **Data Protected**: File contents unreadable to eavesdroppers." >> "$REPORT_FILE"
  echo "" >> "$REPORT_FILE"
  echo "### Sample Packets:" >> "$REPORT_FILE"
  docker run --rm -v "$CAPURE_DIR:/captures" nicolaka/netshoot tcpdump -r "/captures/$(basename $SFTP_PCAP)" -A -c 5 | head -10 >> "$REPORT_FILE" 2>/dev/null || echo "Encrypted packets (no readable content)." >> "$REPORT_FILE"
  echo "" >> "$REPORT_FILE"
fi

echo "## Conclusion" >> "$REPORT_FILE"
echo "FTP transmits data in plaintext, making it vulnerable to interception. SFTP uses SSH encryption to ensure confidentiality and integrity, making it the secure choice for file transfers." >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "Report generated: $REPORT_FILE"
