{
  flake.modules.homeManager.hmuser01 =
    { lib, inputs, ... }:
    let
      userName = "tommaso";
    in
    {

      imports = [
        inputs.impermanence.nixosModules.home-manager.impermanence
      ];

      home = {
        username = userName;
        stateVersion = lib.mkDefault "23.05";
        sessionPath = [ "$HOME/.local/bin" ];
        homeDirectory = "/home/${userName}";
        persistence."/persist/home/${userName}".allowOther = true;
      };
    };
}
