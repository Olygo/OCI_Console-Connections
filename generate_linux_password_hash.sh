#!/bin/bash

# ---------------------------------------------------------------------
# Script: generate_password_hash.sh
#
# Description:
#   This script generates a SHA-512 password hash compatible with /etc/shadow
#   based on a password entered manually by the user.
#   It is especially useful for cases like preparing a cloud-init configuration
#   where you need to set a Linux user password without storing or transmitting
#   the plaintext password.
#
# How it works:
#   - Prompts the user to enter a password twice for confirmation.
#   - Creates a temporary user named "tempuser".
#   - Sets the password, which triggers the system to generate the hash.
#   - Cleans sensitive variables from memory.
#   - Extracts the hash from /etc/shadow.
#   - Deletes the temporary user.
#   - Displays the hash for reuse.
#
# Benefits:
#   - Does not rely on mkpasswd or other external tools.
#   - Works on all Linux distributions.
#   - Avoids writing the plaintext password to disk.
# ---------------------------------------------------------------------

# query user password
read -s -p "Please enter your password : " PASSWORD1
echo
read -s -p "Please confirm your password : " PASSWORD2
echo

# check if passwords match
if [ "$PASSWORD1" != "$PASSWORD2" ]; then
  echo "Error : Passwords do not match."
  exit 1
fi

# create temporary user
sudo useradd tempuser

# set password for temporary user
echo "tempuser:${PASSWORD1}" | sudo chpasswd

# clear variables
PASSWORD1=""
PASSWORD2=""
unset PASSWORD1 PASSWORD2

# fetch password hash
HASH=$(sudo grep '^tempuser:' /etc/shadow | cut -d: -f2)
sudo userdel -r tempuser

# print password hash
echo "$HASH"