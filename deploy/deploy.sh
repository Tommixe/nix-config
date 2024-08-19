#!/usr/bin/env bash
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
    nixos-rebuild --flake ..\#$host switch --target-host $user@$host --use-remote-sudo --use-substitutes $@
    #nixos-rebuild --flake .\#$host switch --build-host $user@$host --target-host $user@$host --use-remote-sudo --use-substitutes $@
done