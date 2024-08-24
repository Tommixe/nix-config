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
    ../common/optional/msmtp.nix
    #../common/optional/tailscale-server.nix
  ];

  # Static IP address
  networking = {
    hostName = "server01";
    useDHCP = true;
    interfaces.ens18 = {
      useDHCP = true;
      wakeOnLan.enable = true; 
    };
  };

  system.stateVersion = "23.05";
}
