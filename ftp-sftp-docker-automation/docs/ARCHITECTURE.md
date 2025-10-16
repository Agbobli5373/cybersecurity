# System Architecture: FTP vs SFTP Docker Automation

## Overview
This system demonstrates the security differences between FTP and SFTP file transfers using containerized environments. It automates the setup, transfer, capture, and analysis of network traffic to highlight plaintext vs. encrypted protocols.

## High-Level Architecture

```mermaid
graph TD
    A[Host System<br/>Ubuntu/Debian<br/>Docker, tcpdump, Bash] --> B[Docker Engine<br/>Compose, Bridge Network]
    B --> C[FTP Server<br/>vsftpd container<br/>Port 2121]
    B --> D[SFTP Server<br/>atmoz/sftp container<br/>Port 2223]
    B --> E[Client<br/>curl container<br/>Performs transfers]
    A --> F[tcpdump<br/>Captures on bridge<br/>Generates PCAP]
    F --> G[PCAP Files<br/>captures/]
    C --> H[Data Flow<br/>FTP Transfer<br/>Plaintext]
    D --> I[Data Flow<br/>SFTP Transfer<br/>Encrypted]
    H --> F
    I --> F
    G --> J[Analysis<br/>tcpdump in container<br/>Markdown Report]
    J --> K[analysis_report.md<br/>Key Findings]
```

## Components

### 1. Host System
- **OS**: Linux (Ubuntu/Debian-based)
- **Tools**:
  - Docker Engine for containerization
  - tcpdump for network packet capture
  - Bash for scripting automation
- **Responsibilities**:
  - Run Docker containers
  - Execute packet capture on Docker bridge interface
  - Orchestrate the demo workflow

### 2. Docker Environment
- **Docker Compose**: Defines and manages multi-container application
- **Network**: Custom bridge network (`ftp-sftp-docker-automation_demo`) for inter-container communication
- **Volumes**: Bind mounts for data persistence and capture storage

### 3. Container Services

#### FTP Server (`ftp`)
- **Image**: fauria/vsftpd
- **Purpose**: Provides insecure FTP service
- **Configuration**:
  - Passive mode enabled
  - User: `student` / Pass: `ftp123`
  - Exposed port: 2121 (host), 21 (container)
- **Data**: Stores uploaded files in `/home/vsftpd/student/uploads`

#### SFTP Server (`sftp`)
- **Image**: atmoz/sftp
- **Purpose**: Provides secure SFTP service over SSH
- **Configuration**:
  - User: `student` / Pass: `sftp123`
  - Directory: `/home/student/upload`
  - Exposed port: 2223 (host), 22 (container)
- **Data**: Stores uploaded files in `/home/student/upload`

#### Client (`ftp-client`)
- **Image**: curlimages/curl
- **Purpose**: Performs file transfers using curl
- **Capabilities**:
  - FTP uploads: `curl --ftp-create-dirs -T file ftp://user:pass@ftp/uploads/file`
  - SFTP uploads: `curl -k -T file sftp://user:pass@sftp:22/upload/file`

### 4. Automation Layer

#### Script (`scripts/run_demo.sh`)
- **Language**: Bash
- **Functions**:
  - Environment setup and teardown
  - Service orchestration
  - Packet capture coordination
  - Report generation
- **Modes**: FTP-only, SFTP-only, or both
- **Flow**:
  1. Start servers
  2. Launch packet capture
  3. Execute file transfer
  4. Stop capture
  5. Generate analysis report

#### Packet Capture
- **Tool**: tcpdump (host-level)
- **Target**: Docker bridge interface (e.g., `br-xxxx`)
- **Filters**: `tcp port 21` (FTP), `tcp port 22` (SFTP)
- **Output**: Timestamped PCAP files in `captures/`

### 5. Data and Outputs

#### Data Directory Structure
```
data/
├── shared/
│   └── sample.txt          # Test file for transfers
├── ftp/
│   └── uploads/            # FTP uploaded files
└── sftp/
    └── uploads/            # SFTP uploaded files

captures/                    # PCAP files
analysis_report.md           # Generated analysis
```

#### Analysis Report
- **Format**: Markdown
- **Content**:
  - Key findings (plaintext vs encrypted)
  - Sample packets
  - Security implications
- **Generation**: Automated using tcpdump in containers

## Data Flow

1. **Setup**: Script starts FTP/SFTP servers on Docker network
2. **Transfer**: Client container uploads sample file via FTP or SFTP
3. **Capture**: Host tcpdump captures traffic on bridge interface
4. **Analysis**: Script analyzes PCAPs and generates report
5. **Output**: PCAP files and markdown report for review

## Security Considerations

- **Isolation**: All services run in containers with limited privileges
- **Network**: Traffic contained within Docker bridge (not exposed externally)
- **Credentials**: Fixed demo credentials (not for production use)
- **Cleanup**: Automatic container and network teardown

## Deployment

- **Prerequisites**: Docker, Docker Compose, tcpdump on host
- **Execution**: `./scripts/run_demo.sh [ftp|sftp|both]`
- **Cleanup**: Automatic via script traps

This architecture provides a self-contained, repeatable lab environment for demonstrating protocol security differences.