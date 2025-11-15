{ config, inputs, ... }:
{
  homeHosts."user01@lp01" = {
    unstable = true;
    modules = with config.flake.modules.homeManager; [
      home-user01
      host_lp01
    ];
  };

  #flake.modules.homeManager.host_lp01 = {
  #  home-manager.users.user01.imports = with config.flake.modules.homeManager; [
  #   base
  #   user01
  #  ];

  flake.modules.homeManager.host_lp01 = {
    imports = with config.flake.modules.homeManager; [
      base
      flatpaks
      kdeconnect
      deluge
      playerctl
      pavucontrol
      firefox
      gnome-extensions
      helix
      ghostty
      imp-home
      imp-options
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
