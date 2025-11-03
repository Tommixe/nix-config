{
  config,
  lib,
  ...
}:
{

  flake.modules.nixos."hosts/lp01".imports =
    # Import the nixos modules for the host `lp01`.
    with config.flake.modules.nixos;
    [
      # Modules
      base
      pipewire
      quietboot
      gnome
      cosmic
      wirelesspersist
      gh-token
      flatpak
      printerhp
      sops
      systemd-boot
      xbootldr.nix
      ephemeral-btrfs-lvm
      # Users
      #root
      user01
    ]
    # Specific Home-Manager modules
    ++ [
      {
        home-manager.users.user01.imports = with config.flake.modules.homeManager; [
          base
          desktop
          dev
          email
          facter
          messaging
          games
          shell
          vpn
          work
        ];
      }
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

  system.stateVersion = "25.05"; 
  
}
