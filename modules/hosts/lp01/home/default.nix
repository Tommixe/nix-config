{ config, inputs,  ... }:
{
  homeHosts."user01@lp01" = {
    unstable = true;
    modules = with config.flake.modules.homeManager; [
      base
      user01
    ];
  };

  #flake.modules.homeManager.host_lp01 = {
  #  home-manager.users.user01.imports = with config.flake.modules.homeManager; [
  #   base
  #   user01
  #  ];

  


  #flake.modules.homeManager.host_lp01 = {
  #  imports = with config.flake.modules.homeManager; [
  #    base
  #    user01
  #  ];

  #};
}
