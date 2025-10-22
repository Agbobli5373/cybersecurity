# FTP vs SFTP Security Demonstration: Presentation Outline

## Slide 1: Title Slide
- **Title**: Demonstrating FTP vs SFTP Security Risks Using Docker Automation
- **Subtitle**: Capstone Project in Network Security
- **Presenter**: [Your Name]
- **Date**: [Current Date]
- **Institution/Organization**: [If applicable]

## Slide 2: Agenda
- Aim and Objectives
- Methodology
- Concept of the Project
- Tools Used
- Results and Analysis
- Conclusion
- References

---

## Section 1: Aim and Objectives

### Slide 3: Aim
- **Main Aim**: To demonstrate the security vulnerabilities of FTP (File Transfer Protocol) compared to the secure SFTP (SSH File Transfer Protocol) through hands-on network traffic analysis.
- Highlight how plaintext data transmission in FTP can be intercepted, while SFTP's encryption protects sensitive information.

### Slide 4: Objectives
- Set up automated environments for FTP and SFTP file transfers using Docker containers.
- Capture and analyze network packets during transfers to reveal plaintext vs. encrypted traffic.
- Generate comparative reports showing exposed credentials and data in FTP versus protected content in SFTP.
- Educate on the importance of secure protocols in modern network communications.
- Provide a repeatable, containerized lab for cybersecurity education.

---

## Section 2: Methodology

### Slide 5: Research Methodology Overview
- **Approach**: Experimental demonstration using containerization for controlled, repeatable testing.
- **Steps**:
  1. Environment Setup: Launch FTP and SFTP servers in Docker containers.
  2. Data Preparation: Use sample files for transfer testing.
  3. Traffic Capture: Employ packet capture tools during file uploads.
  4. Analysis: Examine captured packets for readable content vs. encryption.
  5. Reporting: Generate automated analysis reports with key findings.

### Slide 6: Experimental Setup
- **Network Isolation**: All components run on a Docker bridge network to contain traffic.
- **Transfer Scenarios**:
  - FTP: Plaintext file upload with credential exposure.
  - SFTP: Encrypted file upload over SSH tunnel.
- **Capture Method**: Host-level packet capture on Docker bridge interface using tcpdump.
- **Automation**: Bash scripts orchestrate the entire process for consistency.

### Slide 7: Data Collection
- **Inputs**: Sample text file ("This is a sample file for the FTP vs SFTP demo...")
- **Outputs**:
  - PCAP files containing captured network packets.
  - Uploaded files in persistent volumes.
  - Markdown analysis reports with packet samples and security findings.

---

## Section 3: Concept of the Project

### Slide 8: Project Concept
- **Core Idea**: Practical demonstration of protocol security differences through automation.
- **Problem Statement**: Many systems still use insecure FTP despite known vulnerabilities; SFTP provides a secure alternative.
- **Educational Value**: Visual proof of interception risks vs. encryption benefits.

### Slide 9: Security Principles Demonstrated
- **FTP Vulnerabilities**:
  - Plaintext transmission of commands (USER, PASS) and data.
  - No encryption in transit.
  - Susceptible to eavesdropping, man-in-the-middle attacks.
- **SFTP Advantages**:
  - SSH-based encryption for confidentiality and integrity.
  - Secure authentication and data transfer.
  - Protection against interception and tampering.

### Slide 10: Docker-Based Automation Benefits
- **Containerization**: Isolated, reproducible environments.
- **Scalability**: Easy to deploy and tear down.
- **Safety**: No impact on host system or external networks.
- **Educational**: Simplifies complex networking concepts for students.

---

## Section 4: Tools Used

### Slide 11: Primary Tools
- **Docker & Docker Compose**:
  - Container orchestration and networking.
  - Services: FTP server (vsftpd), SFTP server (atmoz/sftp), client (curl).
- **tcpdump**:
  - Network packet capture and analysis.
  - Captures traffic on Docker bridge interfaces.
- **Bash Scripting**:
  - Automation of demo workflow (run_demo.sh).
  - Report generation and environment management.

### Slide 12: Supporting Tools
- **Wireshark** (optional):
  - GUI-based packet analysis for detailed inspection.
- **curl**:
  - Command-line tool for performing FTP/SFTP transfers.
- **Markdown**:
  - Report formatting for analysis documentation.

### Slide 13: Development Environment
- **Host System**: Linux (Ubuntu/Debian) with Docker Engine.
- **Version Control**: Git for project management.
- **Documentation**: README, architecture diagrams, project briefs.

---

## Section 5: Results and Analysis

### Slide 14: FTP Traffic Analysis
- **Captured Data**: Plaintext commands visible (USER student, PASS ftp123).
- **Security Risk**: File contents and credentials exposed to eavesdroppers.
- **Evidence**: Packet dumps showing readable ASCII data.

### Slide 15: SFTP Traffic Analysis
- **Captured Data**: Encrypted SSH traffic with unreadable payloads.
- **Security Benefit**: Credentials and data protected by encryption.
- **Evidence**: Binary ciphertext in packet captures.

### Slide 16: Comparative Findings
- **FTP**: 27 packets captured, all data readable.
- **SFTP**: 46 packets captured, data encrypted.
- **Key Insight**: Same file transfer - FTP exposes content, SFTP protects it.

---

## Section 6: Conclusion

### Slide 17: Summary of Findings
- FTP's plaintext nature makes it unsuitable for secure file transfers.
- SFTP provides essential encryption for protecting sensitive data in transit.
- Docker automation enables effective, repeatable security demonstrations.

### Slide 18: Implications
- **Practical**: Organizations should migrate from FTP to SFTP for secure communications.
- **Educational**: Hands-on labs improve understanding of network security concepts.
- **Future Work**: Extend to other protocols (HTTP vs HTTPS, etc.) or add advanced analysis features.

### Slide 19: Recommendations
- Use SFTP for all file transfers requiring security.
- Implement network monitoring and encryption best practices.
- Leverage containerization for cybersecurity education and testing.

---

## Section 7: References

### Slide 20: References
- **Docker Documentation**: https://docs.docker.com/
- **tcpdump Manual**: https://www.tcpdump.org/manpages/tcpdump.1.html
- **Wireshark User Guide**: https://www.wireshark.org/docs/wsug_html/
- **SSH/SFTP Standards**: RFC 4251-4254 (Secure Shell Protocol)
- **FTP Standards**: RFC 959 (File Transfer Protocol)
- **Project Repository**: [GitHub URL if applicable]

### Slide 21: Q&A
- Open floor for questions and discussion.
- Thank you for your attention!

---

**Presentation Notes:**
- Use visuals: Include screenshots of packet captures, Docker architecture diagrams, and sample reports.
- Time allocation: 15-20 minutes total.
- Interactive elements: Demo the automation script during the methodology section.
- Backup slides: Additional packet analysis details or troubleshooting tips.




