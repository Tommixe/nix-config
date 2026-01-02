#https://github.com/GaetanLepage/nix-config/blob/master/modules/hosts/framework/default.nix
{
  config,
  lib,
  ...
}:
{
  nixosHosts.hpx360 = {
    unstable = true;
    modules = [ 
         ];
  };

  flake.modules.nixos.host_hpx360 = {
    imports =
      # Import the nixos modules for the host `hpx360`.
      with config.flake.modules.nixos; [
        # Modules
        pipewire
        quietboot
        gnome
        wirelesspersist
        gh-token
        flatpak
        printerhp
        ssh-serve-store
        sops
        systemd-boot
        ephemeral-btrfs # This module will create an ephemeral btrfs root on top of lvm, the module imp is required to manage persistence
        imp # optional to enable persistence i.e. create /persist directories to be preserved by impermanence, can be used without ephemeral-btrfs-lvm
        imp-options # This module must be always turn on even if imp is off automatically add persist directories for some services
        pii
        auto-upgrade
        #hydraAutoUpgrade
      ];
    

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    nixpkgs.config.allowUnfree = true;

    networking = {
      hostName = "hpx360";
      useDHCP = lib.mkDefault true;
      firewall.enable = false;
    };

    networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

    
    system.stateVersion = "23.05";

  };
}
