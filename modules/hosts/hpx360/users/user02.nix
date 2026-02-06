{ config, ... }:
{
  
  # To build HomeConfiguration flake output so it is possibile to run home manager switch without nixos-rebuild
  homeHosts."user02@hpx360" = {
    unstable = true;
    modules = with config.flake.modules.homeManager; [
      home-manager-user02
      host_hpx360_user02
    ];
  };

# Add user02 to host hpx360
  flake.modules.nixos.host_hpx360 = {
    imports =
      with config.flake.modules.nixos; [
      user02 # Define simple linux user
      home-manager-nixoshost-user02  # Enable home manager for user
      ];
  };

# Add host specific homeManager modules and flatpak packages for user02 on host user02
  flake.modules.homeManager.host_hpx360_user02 = {
    imports = with config.flake.modules.homeManager; [
      flatpaks
      playerctl
      pavucontrol
      firefox
      gnome-extensions
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
