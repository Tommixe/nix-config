{ config, ... }:
{
  imports = [
    ./services
    ./hardware-configuration.nix

    ../common/global
    ../common/users/user01
    ../common/optional/fail2ban.nix
    ../common/optional/ephemeral-btrfs.nix
    ../common/optional/docker.nix
    ../common/optional/dockge.nix
    ../common/optional/gh-token.nix
    #../common/optional/portainer.nix
  ];

  # Static IP address
  networking = {
    hostName = "server02";
    useDHCP = true;
    interfaces.ens18 = {
      useDHCP = true;
      wakeOnLan.enable = true;

      ipv4.addresses = [
        {
          address = "cat ${config.sops.secrets.ip-server02.path}";
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
    ip-server02 = {
      sopsFile = ../common/secrets.yaml;
    };
  };

  system.stateVersion = "23.11";
}
