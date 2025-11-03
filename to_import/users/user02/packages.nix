{ pkgs, ... }:
let
  steam-with-pkgs = pkgs.steam.override {
    extraPkgs =
      pkgs: with pkgs; [
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        xorg.libXScrnSaver
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        libkrb5
        keyutils
      ];
  };
in
{
  users.users.user02.packages = with pkgs; [
    firefox
    brave
    bitwarden
    nextcloud-client
    #steam-with-pkgs
    #gamescope
    #protontricks
    #lutris
    #prismlauncher
  ];
}
