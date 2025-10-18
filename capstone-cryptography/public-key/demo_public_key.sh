#!/bin/bash

# Capstone Project: Public Key Encryption / Secure Messaging
# Using GPG for public/private key operations

echo "Generating a new GPG key pair..."
# Note: In a real scenario, you'd provide details interactively, but for demo we'll use defaults
# This will create a key for 'demo@example.com'
echo "Key-Type: RSA
Key-Length: 2048
Subkey-Type: RSA
Subkey-Length: 2048
Name-Real: Demo User
Name-Email: demo@example.com
Expire-Date: 0
%no-protection
%commit" > keygen.txt

gpg --batch --generate-key keygen.txt
rm keygen.txt

echo "Key pair generated."

echo ""
echo "Listing keys:"
gpg --list-keys

echo ""
echo "Creating a sample message..."
echo "This is a secret message to encrypt." > message.txt

echo "Original message:"
cat message.txt

echo ""
echo "Encrypting the message using the public key..."
gpg --encrypt --recipient demo@example.com message.txt

echo "Encrypted file created: message.txt.gpg"

echo ""
echo "Decrypting the message using the private key..."
gpg --decrypt message.txt.gpg > decrypted_message.txt

echo "Decrypted message:"
cat decrypted_message.txt

echo ""
echo "Creating a digital signature..."
gpg --sign message.txt

echo "Signed file created: message.txt.gpg (detached signature)"

echo ""
echo "Verifying the signature..."
gpg --verify message.txt.gpg

echo ""
echo "Cleaning up temporary files..."
rm message.txt.gpg message.txt.asc