{ config, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./services/nix-services.nix

    ../common/global
    ../common/users/user01
    ../common/users/multimedia
    ../common/optional/fail2ban.nix
    ../common/optional/ephemeral-btrfs.nix
    ../common/optional/docker.nix
    ../common/optional/portainer.nix
    ../common/optional/dockge.nix
    ../common/optional/gh-token.nix
    ../common/optional/duplicacy.nix
    #../common/optional/msmtp.nix
    ../common/optional/tailscale-server-local.nix
  ];

  # Static IP address
  networking = {
    hostName = "server01";
    useDHCP = true;
  };


  nixpkgs.config = {
       # FIXME
      #https://discourse.nixos.org/t/solved-sonarr-is-broken-in-24-11-unstable-aka-how-the-hell-do-i-use-nixpkgs-config-permittedinsecurepackages/56828/6
      permittedInsecurePackages = [ 
            "openssl-1.1.1u" 
            "dotnet-runtime-wrapped-6.0.36"
            "aspnetcore-runtime-6.0.36"
            "aspnetcore-runtime-wrapped-6.0.36"
            "dotnet-sdk-6.0.428"
            "dotnet-sdk-wrapped-6.0.428"
            "dotnet-runtime-6.0.36"
      ];
    };

  system.stateVersion = "23.05";
}
