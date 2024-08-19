#!/usr/bin/env bash

# Use the scritp to generate private and public keys for a new host. Run as:
# ./hostkeygen.sh server02 yes bws_access_token bws_project_id
# The first parameter is the host name
# Optionally set the second parameter to 'yes' if you want to save 
#  the private key in your ~/.ssh/ directory. Public key is always saved there.
# The last two parameters are bitwarden secrets manager access token and project id 
# (see https://bitwarden.com/help/secrets-manager-cli/ )
#
# Be aware that running the script multiple time create multiple secrets with the same "key"
# This can be a problem if you are using the install script from this repo, since it looks for
# bws secret by "key" filed.
#
# After keys creation:
# 1. copy public key content in the host file i.e. "hosts/server02/ssh_host_ed25519_hey.pub" using  cat ~/.ssh/ssh_host_server02_ed25519_key.pub
# 2. copy public age key content in sops.yml file using  cat ~/.ssh/age_host_server02_key.pub
# 3. update secrets file to add the new host using: sops updatekeys hosts/common/secrets.yaml 

host="$1"
copyPrivateKey="$2"
token="$3"
bwProjectID="$4"

echo "create temp dir"
temp=$(mktemp -d)
echo $temp
# Function to cleanup temporary directory on exit
cleanup() {
 rm -rf "$temp"
}

trap cleanup EXIT

#Generate ssh host keys
ssh-keygen -t ed25519 -P "" -f "$temp/ssh_host_${host}_ed25519_key" -C "$host"

#Save public key
echo "copying public key"
hostfolder=~/.ssh/${host}
echo "$hostfolder"
mkdir $hostfolder
cp -f "$temp/ssh_host_${host}_ed25519_key.pub" $hostfolder
cat $hostfolder/ssh_host_${host}_ed25519_key.pub | ssh-to-age > $hostfolder/age_host_${host}_key.pub

#if copy private key yes, save a local copy
if [ "$copyPrivateKey"="yes" ]; then
echo "copying private key"
cp -f "$temp/ssh_host_${host}_ed25519_key"  $hostfolder
fi

#if bw token provided
if [ "$token" ]; then
echo "copying private key to bw"
privateKeyBW="$( cat "$temp/ssh_host_${host}_ed25519_key" | tr -d '\n')"
echo "$privateKeyBW"
bws secret create --access-token  "$token"  "$host" -- "$privateKeyBW" "$bwProjectID" 
fi

#print key to copy
echo "ssh host public key"
cat $hostfolder/ssh_host_${host}_ed25519_key.pub
echo "age host public key"
cat $hostfolder/age_host_${host}_key.pub