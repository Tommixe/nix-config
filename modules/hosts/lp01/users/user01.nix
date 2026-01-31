{ config, ... }:
{
  
  # To build HomeConfiguration flake output so it is possibile to run home manager switch without nixos-rebuild
  homeHosts."user01@lp01" = {
    unstable = true;
    modules = with config.flake.modules.homeManager; [
      home-manager-user01
      host_lp01_user01
    ];
  };

# Add user01 to host lp01
  flake.modules.nixos.host_lp01 = {
    imports =
      with config.flake.modules.nixos; [
      user01 # Define simple linux user
      home-manager-nixoshost-user01  # Enable home manager for user
      ];
  };

# Add host specific homeManager modules and flatpak packages for user01 on host lp01
  flake.modules.homeManager.host_lp01_user01 = {
    
    imports = with config.flake.modules.homeManager; [
      flatpaks
      deluge
      playerctl
      pavucontrol
      firefox
      gnome-extensions
      helix
      ghostty
      fastfetch
      onedriver
    ];

    services.flatpak.packages = [
      #{ appId = "com.brave.Browser"; origin = "flathub"; }
      "md.obsidian.Obsidian"
      "io.github.nozwock.Packet"
      "com.bitwarden.desktop"
      "org.onlyoffice.desktopeditors"
      #"im.riot.Riot"
    ];

  };

  

}
