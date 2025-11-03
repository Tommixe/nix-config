{
  imports = [
    #./services
    ./hardware-configuration.nix

    ../common/global
    #../common/global/podman.nix
    ../common/users/user01
    ../common/optional/fail2ban.nix
    ../common/optional/ephemeral-btrfs.nix
    ../common/optional/docker.nix
    ../common/optional/portainer.nix
    #../common/optional/tailscale-exit-node.nix
  ];

  # Static IP address
  networking = {
    hostName = "dev01";
    useDHCP = true;
    #interfaces.enp1s0 = {
    #  useDHCP = true;
    #  wakeOnLan.enable = true;

    #  ipv4.addresses = [{
    #    address = "192.168.122.247";
    #    prefixLength = 24;
    #  }];
    #ipv6.addresses = [{
    #  address = "2804:14d:8084:a484::1";
    #  prefixLength = 64;
    #}];
    #};
  };

  system.stateVersion = "23.05";
}
