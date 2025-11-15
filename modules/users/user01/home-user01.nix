{
  flake.modules.homeManager.home-user01 =
    {
      lib,
      ...
    }:
    let
      userName = "tommaso";
    in
    {

      home = {
        username = userName;
        stateVersion = lib.mkDefault "23.05";
        sessionPath = [ "$HOME/.local/bin" ];
        homeDirectory = "/home/${userName}";
      };

    };
}
