#!/bin/bash

# Capstone Project: Hashing and Integrity Checking
# Using SHA-256 for integrity verification

echo "Creating a sample file..."
echo "This is the original content for hashing demonstration." > original.txt

echo "Original file content:"
cat original.txt

echo ""
echo "Generating SHA-256 hash of the original file..."
original_hash=$(openssl dgst -sha256 original.txt | awk '{print $2}')
echo "Original hash: $original_hash"

echo ""
echo "Modifying the file slightly..."
echo "This is the modified content for hashing demonstration." > modified.txt

echo "Modified file content:"
cat modified.txt

echo ""
echo "Generating SHA-256 hash of the modified file..."
modified_hash=$(openssl dgst -sha256 modified.txt | awk '{print $2}')
echo "Modified hash: $modified_hash"

echo ""
echo "Comparing hashes:"
if [ "$original_hash" == "$modified_hash" ]; then
    echo "Hashes are the same - no tampering detected (but this shouldn't happen with different content)"
else
    echo "Hashes are different - tampering detected!"
fi

echo ""
echo "This demonstrates how hashing can detect file modifications, useful for verifying downloads or backups."