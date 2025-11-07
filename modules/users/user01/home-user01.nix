{
  flake.modules.homeManager.hmuser01 =
    { lib,  ... }:
    let
      userName = "tommaso";
    in
    {
      home = {
        username = userName;
        stateVersion = lib.mkDefault "23.05";
        sessionPath = [ "$HOME/.local/bin" ];
        homeDirectory = "/home/${userName}";
        # persistence."/persist/home/${userName}".allowOther = true;
      };
    };
}
