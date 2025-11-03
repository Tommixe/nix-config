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
    ../features/ghostty
    #./features/pass
    #./features/games
    #./features/music
    ../features/desktop/flatpak
    #flake-inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];

  colorscheme = inputs.nix-colors.colorschemes.atelier-sulphurpool;
  wallpaper = outputs.wallpapers.aenami-northwind;

  services.flatpak.packages = [
    #{ appId = "com.brave.Browser"; origin = "flathub"; }
    "md.obsidian.Obsidian"
    "io.github.nozwock.Packet"
    "com.bitwarden.desktop"
    "org.onlyoffice.desktopeditors"
    #"im.riot.Riot"
  ];

}
