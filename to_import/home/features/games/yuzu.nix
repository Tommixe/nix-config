{
  pkgs,
  lib,
  config,
  ...
}:
{
  home.packages = [ pkgs.yuzu-mainline ];

  home.persistence = {
    "/persist/home/${config.home.username}" = {
      allowOther = true;
      directories = [
        "Games/Yuzu"
        ".config/yuzu"
        ".local/share/yuzu"
      ];
    };
  };
}
