#https://github.com/GaetanLepage/nix-config/blob/master/modules/home/core/default.nix
{
  flake.modules.homeManager.user01 =
    { lib, config, ... }:
    {
      home = {
        username = lib.mkDefault "tommaso";
        stateVersion = lib.mkDefault "23.05";
        sessionPath = [ "$HOME/.local/bin" ];
        homeDirectory = "/home/${config.home.username}";
      };

      custom.imp.root.directories = [ "/home/${config.home.username}" ];

    };
}