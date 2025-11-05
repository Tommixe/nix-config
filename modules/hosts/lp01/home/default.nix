{ config, ... }:
{
  homeHosts.user01 = {
    unstable = true;
  };

  flake.modules.homeManager.base = {
    home-manager.users.user01.imports = with config.flake.modules.homeManager; [
     base
     user01
    ];

  #flake.modules.homeManager.host_lp01 = {
  #  imports = with config.flake.modules.homeManager; [
  #    base
  #    user01
  #  ];

  };
}
