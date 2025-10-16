#!/bin/bash

# Run inside workstation container

echo "Scanning open ports on server..."
nmap -p 1-1000 server

echo "Hardening: Assuming we close unneeded ports by configuring services."
# In real scenario, stop services or configure firewall
# For demo, just note it

echo "Scan complete. In a real setup, close ports like 22 if not needed."