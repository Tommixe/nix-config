{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
{
  imports = [
    #inputs.hardware.nixosModules.common-cpu-amd
    #inputs.hardware.nixosModules.common-gpu-amd
    #inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix

    ../common/global
    ../common/users/user01
    ../common/users/user02
    ../common/global/tailscale.nix

    #../common/optional/gamemode.nix
    #../common/optional/ckb-next.nix
    #../common/optional/greetd.nix
    ../common/optional/pipewire.nix
    ../common/optional/quietboot.nix
    ../common/optional/gnome.nix
    ../common/optional/wirelesspersist.nix
    ../common/optional/gh-token.nix
    ../common/optional/flatpak.nix
    #../common/optional/rstart.nix
    #../common/optional/lol-acfix.nix
    #../common/optional/starcitizen-fixes.nix
    ../common/optional/printerhp.nix
    ../common/optional/garage-s3.nix

  ];

  # TODO: theme "greeter" user GTK instead of using misterio to login
  #services.greetd.settings.default_session.user = "USERNAME";

  networking = {
    hostName = "hpx360";
    useDHCP = lib.mkDefault true;
    firewall.enable = false;
  };

  boot = {
    #kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    binfmt.emulatedSystems = [
      "aarch64-linux"
      "i686-linux"
    ];
  };

  programs = {
    adb.enable = true;
    dconf.enable = true;
    kdeconnect.enable = true;
  };

  #allow rdp
  networking.firewall.allowedTCPPorts = [ 3389 ];
  #allow gsconnect
  networking.firewall = rec {
    allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
    allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
  };

  # xdg.portal = {
  #   enable = true;
  #   wlr.enable = true;
  # };

  /*
    hardware = {
      opengl = {
        enable = true;
        extraPackages = with pkgs; [ amdvlk ];
        driSupport = true;
        driSupport32Bit = true;
      };
      openrgb.enable = true;
      opentabletdriver.enable = true;
    };
  */

/*
  services.garage-s3 = {
    enable = true;
    package = pkgs.garage_2;
    secrets = {
      sopsFile = "./../../hosts/${config.networking.hostName}/secrets.yaml"; #path relative to nixos/modules/garage-s3.nix
      rpcSecret = "rpcSecret";
      adminToken = "adminToken";
    };
    data = {
        dir = "/persist/garage/data";
        capacity = "2G";
      };
    metadataDir = "/persist/garage/metadata";
    rpcPublicAddr = "hpx360:3901";
  };

  #environment.persistence = {
  #  "/persist".directories = [ "/var/lib/garage" ];
  #  };
*/

  system.stateVersion = "23.05";
}
