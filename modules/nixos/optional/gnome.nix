{

  flake.modules.nixos.gnome =
    {
      pkgs,
      ...
    }:
    {
      services = {
        desktopManager.gnome = {
          enable = true;
        };
        displayManager.gdm = {
          enable = true;
          autoSuspend = false;
        };
        geoclue2.enable = true;
        gnome.gnome-remote-desktop.enable = true;
        printing.enable = true;
      };

      environment.systemPackages = [
        # Themes the app titlebars
        pkgs.qadwaitadecorations
        pkgs.qadwaitadecorations-qt6
        # Themes the apps
        pkgs.qgnomeplatform
        pkgs.qgnomeplatform-qt6
      ];

      # Fix broken stuff
      #services.avahi.enable = false;
      # but to rally activate it
      # systemctl --user restart gnome-remote-desktop.service
      networking.networkmanager.enable = true;

      systemd.services.gnome-remote-desktop = {
        wantedBy = [ "graphical.target" ];
      };

      #allow rdp
      networking.firewall.allowedTCPPorts = [ 3389 ];
      networking.firewall.allowedUDPPorts = [ 3389 ];
    };

}
