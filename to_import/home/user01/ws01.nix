{ inputs, outputs, ... }:
{
  imports = [
    ./global
    #./features/desktop/hyprland
    ../features/desktop/gnome
    #./features/rgb
    #./features/productivity
    #../features/nvim
    ../features/helix
    #./features/pass
    #./features/games
    #./features/music
  ];

  colorscheme = inputs.nix-colors.colorschemes.atelier-sulphurpool;
  wallpaper = outputs.wallpapers.aenami-northwind;
}
