{ pkgs, ... }:
{
  fontProfiles = {
    enable = true;
    monospace = {
      family = "FiraCode Nerd Font";
      #package = pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; };
      package = pkgs.nerd-fonts.fira-code;
    };
    regular = {
      family = "Fira Sans";
      package = pkgs.fira;
    };
  };
}
