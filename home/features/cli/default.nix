{ pkgs, ... }:
{
  imports = [
    ./bash.nix
    #./bat.nix
    #./direnv.nix
    ./fish.nix
    ./gh.nix
    ./git.nix
    #./gpg.nix
    #./nix-index.nix
    #./pfetch.nix
    #./ranger.nix
    #./screen.nix
    #./shellcolor.nix
    ./ssh.nix
    #./starship.nix
    ./starship2.nix
    ./clipkgs.nix
    #./xpo.nix
  ];
}
