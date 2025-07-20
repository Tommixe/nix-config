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

   modules.opencloud = {
        enable = true;
        version = "2.0.4";
        port = 11200;
        configDir = "/srv/opencloud/config";
        dataDir = "/srv/opencloud/metadata";
        environmentFiles = [ config.sops.secrets.opencloudEnv.path ];
        domain = "opencloud.tzero.it";
        S3_access_key = "opencloud-key";
        S3_bucket = "opencloud";
        S3_endpoint = "localhost:3900";
        S3_region = "garage";
        S3_secret_key = "cat ${config.sops.secrets.opencloud-s3-key.path}";
    };


  sops.secrets.opencloudEnv = {
    sopsFile = ./opencloud.env;
    format = "dotenv";
  };

  sops.secrets.opencloud-s3-key ={
      sopsFile = ./secrets.yaml;
  };    



  system.stateVersion = "23.05";
}
