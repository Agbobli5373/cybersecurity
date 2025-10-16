# Capstone Project Brief: Demonstrating FTP vs SFTP Security

## Objective
Showcase the risk of transmitting data over unsecured FTP and demonstrate how SFTP mitigates those risks through encryption. Students use Docker-based automation to generate both FTP and SFTP transfers, capture the resulting traffic, and compare the plaintext versus encrypted payloads.

## Scope
- Launch containerized FTP and SFTP environments with predefined credentials.
- Automate sample file transfers so packet captures can be produced on demand.
- Capture traffic with tcpdump for analysis in Wireshark, or via command-line tools for quick inspection.
- Highlight how FTP exposes credentials and content, while SFTP keeps data confidential.

## Key Deliverables
1. **Environment setup**
   - Docker Compose file providing FTP, SFTP, capture, and client services.
   - Sample plaintext file and persisted volumes for uploaded artifacts.
2. **FTP capture and analysis**
   - Packet capture that reveals FTP commands (`USER`, `PASS`) and file contents.
   - Written observations noting exposed credentials and plaintext payloads.
3. **SFTP capture and analysis**
   - Packet capture showing encrypted SSH traffic with unreadable contents.
   - Explanation of why the same sample file is protected in transit.
4. **Comparative report**
   - Summary of security risks inherent to FTP.
   - Description of how SFTP leverages SSH for confidentiality and integrity.
   - Real-world implications advocating secure transfer protocols.

## Recommended Workflow
1. Run `scripts/run_demo.sh` to provision the lab and generate captures.
2. Analyze captures using tcpdump in a container for quick command-line inspection, or open in Wireshark for detailed GUI analysis.
3. Document cleartext FTP traffic (visible USER/PASS commands) versus encrypted SFTP traffic.
4. Grab screenshots of relevant packets (FTP credentials, SFTP ciphertext).
5. Draft the comparative analysis report using the captured evidence.
6. Present findings, emphasizing the importance of secure protocols in daily operations.

## Expected Outcomes
- Direct visualization of intercepted FTP credentials and payloads using Wireshark or tcpdump.
- Appreciation for encryption-in-transit as implemented by SFTP.
- Hands-on practice with Docker, packet capture, and protocol analysis.
