#!/bin/bash

# Capstone Project: Scenario Simulation - Secure Email Exchange
# Simulating secure email exchange between two users using GPG

echo "Setting up two users: Alice and Bob"

# Generate keys for Alice
echo "Generating key for Alice..."
echo "Key-Type: RSA
Key-Length: 2048
Subkey-Type: RSA
Subkey-Length: 2048
Name-Real: Alice
Name-Email: alice@example.com
Expire-Date: 0
%no-protection
%commit" > alice_key.txt

gpg --batch --generate-key alice_key.txt
rm alice_key.txt

# Generate keys for Bob
echo "Generating key for Bob..."
echo "Key-Type: RSA
Key-Length: 2048
Subkey-Type: RSA
Subkey-Length: 2048
Name-Real: Bob
Name-Email: bob@example.com
Expire-Date: 0
%no-protection
%commit" > bob_key.txt

gpg --batch --generate-key bob_key.txt
rm bob_key.txt

echo "Keys generated."

echo ""
echo "Listing all keys:"
gpg --list-keys

echo ""
echo "Alice wants to send a secret message to Bob."

# Alice creates a message
echo "Alice's message: 'Hello Bob, this is a secret message.'" > alice_message.txt

echo "Alice encrypts the message with Bob's public key..."
gpg --encrypt --recipient bob@example.com alice_message.txt

echo "Encrypted email created: alice_message.txt.gpg"

echo ""
echo "Bob receives the encrypted email and decrypts it..."
gpg --decrypt alice_message.txt.gpg > bob_received_message.txt

echo "Bob reads the message:"
cat bob_received_message.txt

echo ""
echo "Bob replies to Alice."

# Bob creates a reply
echo "Bob's reply: 'Hi Alice, thanks for the secret message!'" > bob_reply.txt

echo "Bob encrypts the reply with Alice's public key..."
gpg --encrypt --recipient alice@example.com bob_reply.txt

echo "Encrypted reply created: bob_reply.txt.gpg"

echo ""
echo "Alice receives and decrypts Bob's reply..."
gpg --decrypt bob_reply.txt.gpg > alice_received_reply.txt

echo "Alice reads the reply:"
cat alice_received_reply.txt

echo ""
echo "This demonstrates secure email exchange using public key cryptography."

echo ""
echo "Cleaning up..."
rm alice_message.txt.gpg bob_reply.txt.gpg