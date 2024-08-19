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
    #../common/optional/tailscale-exit-node.nix
  ];

  # Static IP address
  networking = {
    hostName = "server01";
    useDHCP = true;
    interfaces.ens18 = {
      useDHCP = true;
      wakeOnLan.enable = true;

      ipv4.addresses = [
        {
          address = "cat ${config.sops.secrets.ip-server01.path}";
          prefixLength = 24;
        }
      ];
      #ipv6.addresses = [{
      #  address = "2804:14d:8084:a484::1";
      #  prefixLength = 64;
      #}];
    };
  };

  sops.secrets = {
    ip-server01 = {
      sopsFile = ../common/secrets.yaml;
    };
  };

  system.stateVersion = "23.05";
}
