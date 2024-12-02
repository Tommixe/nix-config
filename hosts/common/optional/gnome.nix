{ pkgs, ... }:
{

  # environment.systemPackages = with pkgs; [
  #   gnome.gnome-session
  # ];

  services = {
     xserver = {
       enable = true;
       desktopManager.gnome = {
         enable = true;
       };
       displayManager.gdm = {
         enable = true;
         autoSuspend = false;
       };
     };
    geoclue2.enable = true;
    gnome.gnome-remote-desktop.enable = true;
    printing.enable = true;
    # xrdp.enable = true;
    # xrdp.defaultWindowManager = "${pkgs.gnome.gnome-session}/bin/gnome-session";
    # xrdp.openFirewall = true;
  };
  # Fix broken stuff
  #services.avahi.enable = false;
  networking.networkmanager.enable = true;
}
