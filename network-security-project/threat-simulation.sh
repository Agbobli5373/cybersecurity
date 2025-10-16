#!/bin/bash

# Simulate threat: Port scanning from workstation to server

echo "Simulating unauthorized port scan..."
nmap -sS server

echo "In a secure setup, firewall should block this."
echo "Check firewall logs or use tcpdump to see blocked packets."