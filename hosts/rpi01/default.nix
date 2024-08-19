{ inputs, config, ... }:
{
  imports = [
    #inputs.hardware.nixosModules.raspberry-pi-3b

    #./services
    ./hardware-configuration.nix
    ../common/optional/ephemeral-btrfs.nix

    ../common/global
    ../common/optional/wirelesspersist.nix
    ../common/optional/tailscale-server.nix
    ../common/users/user01
  ];

  # Static IP address
  networking = {
    hostName = "rpi01";
    useDHCP = true;
    interfaces = {
      # TODO change to eth0
      wlan0 = {
        useDHCP = true;
        wakeOnLan.enable = true;
        ipv4.addresses = [
          {
            address = "cat ${config.sops.secrets.ip-rpi.path}";
            prefixLength = 24;
          }
        ];
        #ipv6.addresses = [
        #  {
        #    address = "2804:14d:8082:8bc5::1";
        #    prefixLength = 64;
        #  }
        #];
      };
    };
  };

  sops.secrets = {
    ip-rpi = {
      sopsFile = ../common/secrets.yaml;
    };
  };

  # Enable argonone fan daemon
  #services.hardware.argonone.enable = true;

  # Workaround for https://github.com/NixOS/nixpkgs/issues/154163
  #nixpkgs.overlays = [
  #  (final: prev: {makeModulesClosure = x: prev.makeModulesClosure (x // {allowMissing = true;});})
  #];

  system.stateVersion = "24.05";
}
