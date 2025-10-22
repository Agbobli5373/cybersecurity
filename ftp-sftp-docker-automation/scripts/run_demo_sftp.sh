#!/usr/bin/env bash
# SFTP Demo Script
#
# This script demonstrates SFTP file transfer in a Docker environment.
# It sets up an SFTP server and client, performs a file upload, and captures
# the network traffic using tcpdump for analysis.
#
# Prerequisites:
# - Docker and Docker Compose V2 must be installed
# - sudo access for tcpdump (packet capture)
#
# Usage:
#   ./run_demo_sftp.sh
#
# The script will:
# 1. Start the SFTP service using Docker Compose
# 2. Upload a sample file via SFTP
# 3. Capture the SFTP traffic (port 22) to a pcap file
# 4. Save the capture in the captures/ directory
#
# Output:
# - A pcap file named sftp_transfer_YYYYMMDD_HHMMSS.pcap in captures/
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
SFTP_UPLOAD_DIR="$ROOT_DIR/data/sftp/uploads"
COMPOSE="docker compose"

mkdir -p "$CAPTURE_DIR" "$SFTP_UPLOAD_DIR"

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

$COMPOSE up -d sftp >/dev/null

# Allow services enough time to become ready.
sleep 5

# Get the bridge interface name for packet capture
NETWORK_ID=$(docker network ls --filter name=ftp-sftp-docker-automation_demo -q)
BRIDGE_NAME="br-$(docker network inspect $NETWORK_ID | grep '"Id"' | head -1 | cut -d'"' -f4 | cut -c1-12)"

timestamp() {
  date +%Y%m%d_%H%M%S
}

run_sftp_transfer() {
  echo "Starting SFTP upload"
  $COMPOSE run --rm ftp-client "curl --silent --show-error -k -T /data/sample.txt sftp://student:sftp123@sftp:22/upload/sample.txt"
  echo "SFTP upload complete"
}

sftp_capture_name="sftp_transfer_$(timestamp).pcap"
echo "Capturing SFTP traffic to $sftp_capture_name"
sudo tcpdump -i "$BRIDGE_NAME" -w "$CAPTURE_DIR/$sftp_capture_name" tcp port 22 &
sftp_capture_pid=$!
sleep 2
if ! run_sftp_transfer; then
  echo "SFTP transfer failed" >&2
  exit 1
fi
wait "$sftp_capture_pid" || true
echo "SFTP capture saved as $sftp_capture_name"
echo