#!/bin/bash

# Capstone Project: Data Protection with Encryption
# Using OpenSSL for AES symmetric encryption

echo "Creating a sample file..."
echo "This is a secret message for encryption demonstration." > sample.txt

echo "Original file content:"
cat sample.txt

echo ""
echo "Encrypting the file with AES-256-CBC..."
openssl enc -aes-256-cbc -salt -in sample.txt -out sample.enc -k mysecretpassword

echo "Encrypted file created: sample.enc"

echo ""
echo "Decrypting the file..."
openssl enc -d -aes-256-cbc -in sample.enc -out sample_decrypted.txt -k mysecretpassword

echo "Decrypted file content:"
cat sample_decrypted.txt

echo ""
echo "Verifying if original and decrypted match:"
if cmp -s sample.txt sample_decrypted.txt; then
    echo "SUCCESS: Files match!"
else
    echo "ERROR: Files do not match!"
fi