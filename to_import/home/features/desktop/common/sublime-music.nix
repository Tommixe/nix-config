{
  pkgs,
  lib,
  config,
  ...
}:
{
  home.packages = [ pkgs.sublime-music ];
  home.persistence = {
    "/persist/home/${config.home.username}".directories = [ ".config/sublime-music" ];
  };
}
