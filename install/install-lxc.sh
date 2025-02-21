#!/usr/bin/env bash

host="$1"
toip="$2"
token="$3"

# Authenticate with Bitwarden Secret Manger using the access tokeny and fetch the SSH private key
# Attention! private key must be saved in bw as a single line using "cat ~/.ssh/id_rsa.pub | tr -d '\n' 
# before copy&past in the web interface

echo "Fetching SSH private key from Bitwarden..."
private_key=$(bws secret list --access-token  "$token" | jq '.[] | select(.key=='\""$host"\"') | .value' )
echo "$private_key"


# Check if the private key is found
if [ -z "$private_key" ]; then
echo "Failed to fetch SSH private key. Exiting."
exit 1
fi

# Save the private key to a temporary file

# Create a temporary directory
temp=$(mktemp -d)

# Function to cleanup temporary directory on exit
cleanup() {
 rm -rf "$temp"
}

trap cleanup EXIT

# Create the directory where sshd expects to find the host keys
install -d -m755 "$temp/persist/etc/ssh"

# Decrypt your private key from the password store and copy it to the temporary directory
echo "$private_key" | tr -d '"' >  "$temp/persist/etc/ssh/ssh_host_ed25519_key"
sed -i -e "s/-----BEGIN OPENSSH PRIVATE KEY-----/&\n/"\
    -e "s/-----END OPENSSH PRIVATE KEY-----/\n&/"\
    -e "s/\S\{70\}/&\n/g"\
    "$temp/persist/etc/ssh/ssh_host_ed25519_key"
# Set the correct permissions so sshd will accept the key
chmod 600 "$temp/persist/etc/ssh/ssh_host_ed25519_key"
echo "PRINT"
echo "$temp/persist/etc/ssh/ssh_host_ed25519_key"

#copy ssh host key to the LXC container using private key ~/.ssh/nixinstall created during container installation performed with my Ansible script
echo "Create dir"
ssh root@$toip  -i ~/.ssh/nixinstall -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no 'mkdir -p /persist/etc/ssh/'
echo "Copy dir"
scp "$temp/persist/etc/ssh/ssh_host_ed25519_key" root@$toip:/persist/etc/ssh/ssh_host_ed25519_key #-i ~/.ssh/nixinstall -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no 

# Install NixOS to the host system with our secrets
nixos-rebuild --flake ..\#$host switch --target-host root@$toip --use-remote-sudo
