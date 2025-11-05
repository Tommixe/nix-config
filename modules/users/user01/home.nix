#https://github.com/GaetanLepage/nix-config/blob/master/modules/home/core/default.nix
topLevel@{ lib, config, inputs, ... }:
{

  homeHosts.user01 = {
    unstable = true;
    modules = with config.flake.modules.homeManager; [
      base
      user01
    ];
  };

  flake.modules.homeManager.user01 =
    { lib, config, ... }:
    {
      imports = [
        inputs.impermanence.nixosModules.home-manager.impermanence
      ];

      home = {
        username = lib.mkDefault "tommaso";
        stateVersion = lib.mkDefault "23.05";
        sessionPath = [ "$HOME/.local/bin" ];
        homeDirectory = "/home/${config.home.username}";
        persistence."/persist/home/${config.home.username}".allowOther = true;
      };

      #custom.imp.homeManager.directories = [ "/home/${config.home.username}" ];

    };
}
