#!/usr/bin/env bash
# Run as: sh deploy-rb.sh username 192.168.1.10
# The first argument is the user name of a user that has sudo rights on remote host. For example the one created during installation with install.sh script
# The second argument is the ip or host name of the machine you want to rebuild

export NIX_SSHOPTS="-A"

build_remote=false

user="$1"
hosts="$2"
shift

if [ -z "$hosts" ]; then
    echo "No hosts to deploy"
    exit 2
fi

for host in ${hosts//,/ }; do
    nixos-rebuild --flake ..\#$hosts switch --build-host $user@$host --target-host $user@$host --use-remote-sudo 
--use-substitutes $@
done
