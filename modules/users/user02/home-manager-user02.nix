#Home manager configuration for user02
#Define all features common to all hosts for user02 even of different OS
{
  flake.modules.homeManager.home-manager-user02 =
    {
      lib,
      inputs,
      ...
    }:
    let
      userName = inputs.pconf.global-var.user02;
    in
    {

      home = {
        username = userName;
        stateVersion = lib.mkDefault "23.05";
        sessionPath = [ "$HOME/.local/bin" ];
        homeDirectory = "/home/${userName}";
      };


      # Base module are imported also in host.nix but if not here
      # it won't be available when building only home manager configuration in nixos rebuild
      imports = with inputs.self.modules.homeManager; [
        bash
        fish
        git
      ];

    };
}
