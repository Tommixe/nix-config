{ config, ... }:
{
  homeHosts."user01@server02" = {
    unstable = false;
    modules = with config.flake.modules.homeManager; [
      home-manager-user01
      host_server02_user01
    ];
  };

  flake.modules.nixos.host_server02 = {
    imports = with config.flake.modules.nixos; [
      user01
      home-manager-nixoshost-user01
    ];
  };

  flake.modules.homeManager.host_server02_user01 = {
    imports = with config.flake.modules.homeManager; [
      imp-options
    ];
  };
}
