{
  inputs,
  lib,
  pkgs,
  config,
  outputs,
  ...
}:
let
  username = "federico";  
in
{
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ] ++ (builtins.attrValues outputs.homeManagerModules);


  programs = {
    home-manager.enable = true;
  };

  home = {
    username = "${username}";
    homeDirectory = lib.mkDefault "/home/${username}";
    stateVersion = lib.mkDefault "23.05";
    sessionPath = [ "$HOME/.local/bin" ];
    persistence."/persist/home/${username}".allowOther = true;
  };

}
