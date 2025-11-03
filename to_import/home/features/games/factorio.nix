{
  lib,
  pkgs,
  config,
  ...
}:
{
  home = {
    packages = [ pkgs.factorio ];
    persistence = {
      "/persist/home/${config.home.username}" = {
        allowOther = true;
        directories = [ ".factorio" ];
      };
    };
  };
}
