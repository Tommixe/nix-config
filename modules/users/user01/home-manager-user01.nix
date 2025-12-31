#Home manager configuration for user01
#Define all features common to all hosts for user01 even of different OS
{
  flake.modules.homeManager.home-manager-user01 =
    {
      lib,
      inputs,
      ...
    }:
    let
      userName = inputs.pconf.global-var.user01;
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
        base
      ];

    };
}
