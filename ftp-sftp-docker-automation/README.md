# FTP vs SFTP Docker Automation Demo

This folder contains a lightweight Docker-based lab that automates the core tasks from the FTP vs SFTP security capstone. Containers stand in for both servers and clients, making it easy to demonstrate how plaintext FTP traffic differs from encrypted SFTP traffic.

## Features
- Runs FTP and SFTP servers with fixed lab credentials.
- Uses a curl-based client container to automate file transfers.
- Provides a tcpdump utility container for capturing packet traces.
- Ships with a sample plaintext file and a helper script to orchestrate the demo end-to-end.

## Prerequisites
- Docker Engine 24+ and Docker Compose V2 (`docker compose` CLI).
- Permission to run containers with `NET_ADMIN` and `NET_RAW` capabilities (required for packet capture).

## Quick start
1. Change into this directory:
   ```bash
   cd ftp-sftp-docker-automation
   ```
2. Make the automation script executable the first time:
   ```bash
   chmod +x scripts/run_demo.sh
   ```
3. Run the demo (both FTP and SFTP):
   ```bash
   scripts/run_demo.sh
   ```
   Or run separately:
   ```bash
   scripts/run_demo.sh ftp    # Only FTP demo
   scripts/run_demo.sh sftp   # Only SFTP demo
   ```
   The script will:
   - Launch the FTP and/or SFTP servers.
   - Capture traffic while uploading `data/shared/sample.txt`.
   - Stop and clean up the containers.
   - Generate an `analysis_report.md` with key findings and packet samples.

Packet captures are written to `captures/` with timestamped filenames. Open them in Wireshark to examine the plaintext FTP payloads versus encrypted SFTP payloads.

Uploaded files persist inside the bind mounts so you can inspect them after each run:
- FTP uploads land under `data/ftp/uploads`.
- SFTP uploads land under `data/sftp/uploads`.

## Analyzing Captures
To quickly analyze captures without Wireshark, use tcpdump in a container:
```bash
# For FTP (shows plaintext commands and data)
docker run --rm -v $(pwd)/captures:/captures nicolaka/netshoot tcpdump -r /captures/ftp_transfer_*.pcap -A | head -50

# For SFTP (shows encrypted traffic)
docker run --rm -v $(pwd)/captures:/captures nicolaka/netshoot tcpdump -r /captures/sftp_transfer_*.pcap -A | head -50
```
This reveals FTP's cleartext vulnerabilities versus SFTP's encryption.

## Manual use
You can run the components individually with Docker Compose profiles:
- `docker compose up ftp sftp` starts only the servers.
- `docker compose run --rm ftp-client "curl --ftp-create-dirs -T /data/sample.txt ftp://student:ftp123@ftp/uploads/sample.txt"` performs the FTP upload manually.
- `docker compose run --rm ftp-client "curl -k -T /data/sample.txt sftp://student:sftp123@sftp:22/sample.txt"` performs the SFTP upload.
- For traffic visualization, copy the PCAP files from `captures/` to your host machine and open them in Wireshark or a similar tool to inspect packets and payloads.
- `docker compose run --rm capture -i any -w /captures/manual.pcap tcp port 21` captures FTP traffic; switch the filter to `tcp port 22` for SFTP.

## Credentials
- FTP: `student / ftp123`
- SFTP: `student / sftp123`

## Next steps
- Review the generated `analysis_report.md` for automated findings.
- Import the generated PCAP files into Wireshark for deeper inspection.
- Integrate the captures and analysis into your capstone report template.
