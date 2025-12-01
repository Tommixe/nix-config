{
  flake.modules.homeManager.home-user01 =
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

    };
}
