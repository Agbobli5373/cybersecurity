#!/usr/bin/env bash
# FTP Demo Script
#
# This script demonstrates FTP file transfer in a Docker environment.
# It sets up an FTP server and client, performs a file upload, and captures
# the network traffic using tcpdump for analysis.
#
# Prerequisites:
# - Docker and Docker Compose V2 must be installed
# - sudo access for tcpdump (packet capture)
#
# Usage:
#   ./run_demo_ftp.sh
#
# The script will:
# 1. Start the FTP service using Docker Compose
# 2. Upload a sample file via FTP
# 3. Capture the FTP traffic (port 21) to a pcap file
# 4. Save the capture in the captures/ directory
#
# Output:
# - A pcap file named ftp_transfer_YYYYMMDD_HHMMSS.pcap in captures/
# - Console output showing progress and completion status

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
COMPOSE="docker compose"

mkdir -p "$CAPTURE_DIR" "$FTP_UPLOAD_DIR"

if [ ! -s "$SHARED_SAMPLE" ]; then
  cat <<'EOF' >"$SHARED_SAMPLE"
This is a sample file for the FTP vs SFTP demo.
It contains plain text to illustrate why encryption matters.
EOF
fi

cd "$ROOT_DIR"

cleanup() {
  $COMPOSE down --remove-orphans >/dev/null 2>&1 || true
}
trap cleanup EXIT

$COMPOSE down --remove-orphans >/dev/null 2>&1 || true

$COMPOSE up -d ftp >/dev/null

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

ftp_capture_name="ftp_transfer_$(timestamp).pcap"
echo "Capturing FTP traffic to $ftp_capture_name"
sudo tcpdump -i "$BRIDGE_NAME" -w "$CAPTURE_DIR/$ftp_capture_name" tcp port 21 &
ftp_capture_pid=$!
sleep 2
if ! run_ftp_transfer; then
  echo "FTP transfer failed" >&2
  exit 1
fi
wait "$ftp_capture_pid" || true
echo "FTP capture saved as $ftp_capture_name"
echo