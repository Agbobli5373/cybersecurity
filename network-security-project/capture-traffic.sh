#!/bin/bash

# Run inside workstation container

echo "Capturing traffic for 10 seconds..."
tcpdump -i any -w capture.pcap -c 10

echo "Capture saved to capture.pcap. Analyze with Wireshark if possible."
# To view: tcpdump -r capture.pcap