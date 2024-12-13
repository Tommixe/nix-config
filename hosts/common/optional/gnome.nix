{

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

  };
  # Fix broken stuff
  #services.avahi.enable = false;
  networking.networkmanager.enable = true;

  
}
