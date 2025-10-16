# Network Architecture Diagram

```mermaid
graph TD
    A[Internet] -->|"External Access"| B[Router/Firewall<br/>Docker Network Gateway<br/>iptables Rules]
    B -->|"Allowed: HTTP (Port 80)"| C[Office Network<br/>Subnet: 172.20.0.0/16]
    B -->|"Allowed: Limited Access"| D[Guest Wi-Fi<br/>Subnet: 172.21.0.0/16]
    C -->|"Internal Traffic"| E[Workstation<br/>Container: workstation<br/>Tools: Nmap, tcpdump]
    C -->|"HTTP Requests"| F[Server<br/>Container: server<br/>Service: Nginx on port 80]
    D -->|"Isolated"| G[IoT Device<br/>Container: iot-device<br/>Simulated Device]
    
    E -.->|"Ping Allowed"| F
    G -.->|"Ping Blocked"| F
    E -.->|"Nmap Scan"| F
    B -.->|"Blocks Unauthorized"| A

    style B fill:#f9f,stroke:#333,stroke-width:2px
    style C fill:#bbf,stroke:#333
    style D fill:#bfb,stroke:#333
```

## Explanation
- **Internet**: External connection (simulated).
- **Router/Firewall**: Acts as gateway with iptables rules for security.
- **Office Network**: Segmented subnet for trusted devices; allows internal traffic and HTTP.
- **Guest Wi-Fi**: Isolated subnet for less trusted devices; limited cross-network access.
- **Traffic Flows**:
  - Solid arrows: Allowed paths (e.g., HTTP from internet to server).
  - Dotted arrows: Blocked or simulated interactions (e.g., ping from IoT to server is blocked).
- **Devices**: Containers simulating real network components.

This diagram can be rendered in Markdown viewers like GitHub or VS Code with Mermaid extension.