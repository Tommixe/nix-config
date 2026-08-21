#https://github.com/GaetanLepage/nix-config/blob/master/modules/hosts/framework/default.nix
{
  config,
  lib,
  ...
}:
{
  nixosHosts.lp01 = {
    unstable = true;
    modules = [ 
         ];
  };

  flake.modules.nixos.host_lp01 = {
    imports =
      # Import the nixos modules for the host `lp01`.
      with config.flake.modules.nixos; [
        # Modules
        pipewire
        quietboot
        gnome
        #kde
        cosmic
        wirelesspersist
        gh-token
        flatpak
        printerhp
        ssh-serve-store
        sops
        systemd-boot
        systemd-initrd
        xbootldr
        ephemeral-btrfs-lvm # This module will create an ephemeral btrfs root on top of lvm, the module imp is required to manage persistence
        imp # optional to enable persistence i.e. create /persist directories to be preserved by impermanence, can be used without ephemeral-btrfs-lvm
        imp-options # This module must be always turn on even if imp is off automatically add persist directories for some services
        pii
        auto-upgrade
        #hydraAutoUpgrade
        yubikey
        #incus
        virt-manager
      ];
    
    nixpkgs.config.allowUnfree = true;

    networking = {
      hostName = "lp01";
      useDHCP = lib.mkDefault true;
      firewall.enable = false;
    };

    networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

    # Enable fractional scaling
    services.desktopManager.gnome.extraGSettingsOverrides= ''
      [org.gnome.mutter]
      experimental-features=['scale-monitor-framebuffer', 'xwayland-native-scaling']
    '';

    system.stateVersion = "25.05";

  };
}
