{ config, ... }:
{
  homeHosts."user01@ws01" = {
    unstable = false;
    modules = with config.flake.modules.homeManager; [
      home-manager-user01
      host_ws01_user01
    ];
  };

  flake.modules.nixos.host_ws01 = {
    imports = with config.flake.modules.nixos; [
      user01
      home-manager-nixoshost-user01
    ];
  };

  flake.modules.homeManager.host_ws01_user01 = {
    imports = with config.flake.modules.homeManager; [
      imp-options
      gnome-extensions
      helix
      home-pkgs
    ];
  };
}
