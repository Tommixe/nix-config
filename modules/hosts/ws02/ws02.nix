#https://github.com/GaetanLepage/nix-config/blob/master/modules/hosts/framework/default.nix
{
  config,
  lib,
  pkgs,
  ...
}:
{
  nixosHosts.ws02 = {
    unstable = false;
    modules = [ 
         ];
  };

  flake.modules.nixos.host_ws02 = {
    imports =
      # Import the nixos modules for the host `ws02`.
      with config.flake.modules.nixos; [
        # Modules
        pipewire
        quietboot
        gnome
        wirelesspersist
        gh-token
        flatpak
        printerhp
        msmtp
        hydra
        hydra-machines
        acme
        binary-cache
        sops
        systemd-boot
        systemd-initrd
        ephemeral-btrfs # This module will create an ephemeral btrfs root on top of lvm, the module imp is required to manage persistence
        imp # optional to enable persistence i.e. create /persist directories to be preserved by impermanence, can be used without ephemeral-btrfs-lvm
        imp-options # This module must be always turn on even if imp is off automatically add persist directories for some services
        pii
        auto-upgrade
      ];
    
    nixpkgs.config.allowUnfree = true;

    networking = {
      hostName = "ws02";
      useDHCP = lib.mkDefault true;
    };

    networking.networkmanager.enable = true;

    networking.interfaces.eno1.wakeOnLan = {
      enable = true;
      policy = [ "magic" ];
    };
    
    # Use a systemd service to persist the setting
    systemd.services.wol = {
      description = "Enable Wake-on-LAN";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.ethtool}/bin/ethtool -s eno1 wol g";
        RemainAfterExit = true;
      };
      wantedBy = [ "multi-user.target" ];
    };

    environment.persistence = {
      "/persist" = {
        hideMounts = true;
        directories = [
          "/var/lib/gnome-remote-desktop/"
        ];
      };
    };

    #allow gsconnect
    networking.firewall = rec {
      allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
      allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
    };

    programs = {
      adb.enable = true;
      dconf.enable = true;
    };

    system.stateVersion = "23.11";

  };
}
