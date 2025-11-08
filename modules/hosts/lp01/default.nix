#https://github.com/GaetanLepage/nix-config/blob/master/modules/hosts/framework/default.nix
{
  config,
  lib,
  inputs,
  ...
}:
{
  nixosHosts.lp01 = {
    unstable = true;
    modules = [ inputs.home-manager-unstable.nixosModules.default ];
  };

  flake.modules.nixos.host_lp01 = {
    imports =
      # Import the nixos modules for the host `lp01`.
      with config.flake.modules.nixos; [
        # Modules
        base
        pipewire
        quietboot
        gnome
        cosmic
        #wirelesspersist
        gh-token
        flatpak
        printerhp
        sops
        systemd-boot
        xbootldr
        ephemeral-btrfs-lvm
        imp
        imp-options
        pii
        hydraAutoUpgrade
        # Users
        #root
        user01
        # Home manager for users
        home-manager-user01
      ];
    

    facter.reportPath = ./facter.json;


    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    nixpkgs.config.allowUnfree = true;

    networking = {
      hostName = "lp01";
      useDHCP = lib.mkDefault true;
      firewall.enable = false;
    };

    networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

    # Enable fractional scaling
    services.xserver.desktopManager.gnome.extraGSettingsOverrides = ''
      [org.gnome.mutter]
      experimental-features=['scale-monitor-framebuffer', 'xwayland-native-scaling']
    '';

    system.stateVersion = "25.05";

  };
}
