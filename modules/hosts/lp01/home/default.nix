{ config, ... }:
{
  homeHosts.lp01 = {
    unstable = true;
  };

  flake.modules.homeManager.host_lp01= {
    home-manager.users.user01.imports = with config.flake.modules.homeManager; [
     base
     user01
    ];
  };
}