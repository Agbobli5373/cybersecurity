#!/bin/bash

# Run all cryptography demos

echo "========================================"
echo "Capstone Project: Cryptography Demos"
echo "========================================"

echo ""
echo "1. Running Data Protection with Encryption Demo"
echo "-----------------------------------------------"
cd encryption
./demo_encryption.sh

echo ""
echo "========================================"
echo "2. Running Hashing and Integrity Demo"
echo "--------------------------------------"
cd ../hashing
./demo_hashing.sh

echo ""
echo "========================================"
echo "3. Running Public Key Encryption Demo"
echo "--------------------------------------"
cd ../public-key
./demo_public_key.sh

echo ""
echo "========================================"
echo "4. Running Secure Email Exchange Demo"
echo "--------------------------------------"
cd ../scenario
./demo_secure_email.sh

echo ""
echo "========================================"
echo "All demos completed!"
echo "========================================"