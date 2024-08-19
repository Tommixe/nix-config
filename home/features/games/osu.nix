{
  pkgs,
  lib,
  config,
  ...
}:
{
  home.packages = [ pkgs.osu-lazer ];

  home.persistence = {
    "/persist/home/${config.home.username}".directories = [ ".local/share/osu" ];
  };
}
