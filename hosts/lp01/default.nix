{
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [
   

    ./hardware-configuration.nix

    ../common/global
    ../common/users/user01
    #../common/users/user02
    ../common/global/tailscale.nix
    ../common/optional/pipewire.nix
    ../common/optional/quietboot.nix
    ../common/optional/gnome.nix
    ../common/optional/wirelesspersist.nix
    ../common/optional/gh-token.nix
    ../common/optional/flatpak.nix
    ../common/optional/printerhp.nix
    #Use systemd-boot
    ../common/optional/systemd-boot.nix
    #Use xbootldr
    ../common/optional/xbootldr.nix

  ];

  boot.initrd.luks.devices = {
      enc = {
        # Use https://nixos.wiki/wiki/Full_Disk_Encryption
        device = "/dev/disk/by-uuid/34c8895b-50a7-476e-8fff-c897238d5720";
        preLVM = true;
      };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  networking = {
    hostName = "lp01";
    useDHCP = lib.mkDefault true;
    firewall.enable = false;
  };

  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Enable fractional scaling  
  services.xserver.desktopManager.gnome.extraGSettingsOverrides = ''
    [org.gnome.mutter]
    experimental-features=['scale-monitor-framebuffer', 'xwayland-native-scaling']
  '';


  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;



  system.stateVersion = "25.05"; 
  
}
