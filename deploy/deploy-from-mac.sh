#!/usr/bin/env bash
# The script assume that you run the docker container with "make tools" where user ssh folder is mapped to root/.ssh
# Run as: sh deploy-from-mac.sh username server01 
# you must be able to resolve server01 ip adddress
# The first argument is the user name of a user that has sudo rights on remote host. For example the one created during installation with install.sh script
# The second argument is the ip or host name of the machine you want to rebuild
# The script is works from MacOS because it uses the option "--fast" see: https://www.tweag.io/blog/2023-02-09-nixos-vm-on-macos/
# "....You also have to use --fast because by default nixos-rebuild builds Nix and itself from the NixOS configuration that you provide to it, 
#  and those are Linux binaries "
# --use-substitutes $@
# ...

user="$1"
hosts="$2"

export NIX_SSHOPTS="-A -i ~/.ssh/$user"
eval "$(ssh-agent -s)"
#ssh-add -l |grep -q `ssh-keygen -lf /root/.ssh/$user  | awk '{print $2}'` || eval "$(ssh-agent -s)" && ssh-add /root/.ssh/$user
ssh-add ~/.ssh/$user

shift

if [ -z "$hosts" ]; then
    echo "No hosts to deploy"
    exit 2
fi

for host in ${hosts//,/ }; do
    nixos-rebuild --flake ..\#$host switch --build-host $user@$host --target-host $user@$host --use-remote-sudo --fast 
    --use-substitutes $@
done