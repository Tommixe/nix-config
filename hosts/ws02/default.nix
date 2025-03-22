{ lib, config, ... }:
{
  imports = [
    ./services
    ./hardware-configuration.nix

    ../common/global
    ../common/users/user01
    ../common/optional/ephemeral-btrfs.nix
    ../common/global/tailscale.nix
    ../common/optional/pipewire.nix
    ../common/optional/quietboot.nix
    ../common/optional/gnome.nix
    ../common/optional/wirelesspersist.nix
    ../common/optional/gh-token.nix
    ../common/optional/flatpak.nix
    ../common/optional/printerhp.nix
    ../common/optional/msmtp.nix
    
  ];

  
  networking = {
    hostName = "ws02";
    useDHCP = lib.mkForce true;
  };
  
  
  # # Static IP address
  # networking = {
  #   hostName = "ws01";
  #   useDHCP = false;
  #   defaultGateway = "cat ${config.sops.secrets.ip-router.path}";
  #   nameservers = [
  #     "cat ${config.sops.secrets.ip-ottoserver.path}"
  #     "cat ${config.sops.secrets.ip-router.path}"
  #     "9.9.9.9"
  #   ];
  #   interfaces.ens18 = {
  #     #useDHCP = lib.mkDefault true;
  #     wakeOnLan.enable = true;

  #     ipv4.addresses = [
  #       {
  #         address = "cat ${config.sops.secrets.ip-ws01.path}";
  #         prefixLength = 24;
  #       }
  #     ];

  #     #ipv6.addresses = [{
  #     #  address = "2804:14d:8084:a484::1";
  #     #  prefixLength = 64;
  #     #}];
  #   };
  # };

 
  #allow gsconnect
  networking.firewall = rec {
    allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
    allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
  };

  programs = {
    adb.enable = true;
    dconf.enable = true;
    #kdeconnect.enable = true;
  };

  sops.secrets = {
    ip-ws01 = {
      sopsFile = ../common/secrets.yaml;
    };
    ip-router = {
      sopsFile = ../common/secrets.yaml;
    };
    ip-ottoserver = {
      sopsFile = ../common/secrets.yaml;
    };
  };

  system.stateVersion = "23.11";
}
