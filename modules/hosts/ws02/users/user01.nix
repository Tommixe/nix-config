{ config, ... }:
{
  
  # To build HomeConfiguration flake output so it is possibile to run home manager switch without nixos-rebuild
  homeHosts."user01@ws02" = {
    unstable = true;
    modules = with config.flake.modules.homeManager; [
      home-manager-user01
      host_ws02_user01
    ];
  };

# Add user01 to host ws02
  flake.modules.nixos.host_ws02 = {
    imports =
      with config.flake.modules.nixos; [
      user01 # Define simple linux user
      home-manager-nixoshost-user01  # Enable home manager for user
      ];
  };

# Add host specific homeManager modules and flatpak packages for user01 on host ws02
  flake.modules.homeManager.host_ws02_user01 = {
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
      home-pkgs
    ];

    services.flatpak.packages = [
      #{ appId = "com.brave.Browser"; origin = "flathub"; }
      "md.obsidian.Obsidian"
      "io.github.nozwock.Packet"
      "com.bitwarden.desktop"
      #"im.riot.Riot"
    ];

  };

  

}
