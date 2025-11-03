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


  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
      };
  };

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
    };
  };


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
