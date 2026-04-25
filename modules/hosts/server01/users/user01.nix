{ config, ... }:
{
  homeHosts."user01@server01" = {
    unstable = false;
    modules = with config.flake.modules.homeManager; [
      home-manager-user01
      host_server01_user01
    ];
  };

  flake.modules.nixos.host_server01 = {
    imports = with config.flake.modules.nixos; [
      user01
      home-manager-nixoshost-user01
    ];
  };

  flake.modules.homeManager.host_server01_user01 = {
    imports = with config.flake.modules.homeManager; [
      imp-options
    ];
  };
}
