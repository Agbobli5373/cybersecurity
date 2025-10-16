#!/bin/bash

# Apply basic firewall rules on router-firewall container
# This script should be run inside the container

# Allow loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Allow established connections
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Allow SSH (if needed, but for simulation, maybe not)
# iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Allow HTTP to server
iptables -A FORWARD -i office -o office -p tcp --dport 80 -j ACCEPT

# Block all other incoming traffic
iptables -A INPUT -j DROP
iptables -A FORWARD -j DROP

# Allow outgoing traffic
iptables -A OUTPUT -j ACCEPT

echo "Firewall rules applied."