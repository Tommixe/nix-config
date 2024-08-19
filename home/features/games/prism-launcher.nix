{ pkgs, lib, ... }:
{
  home.packages = [ pkgs.prismlauncher-qt5 ];

  home.persistence = {
    "/persist/home/${config.home.username}".directories = [ ".local/share/PrismLauncher" ];
  };
}
