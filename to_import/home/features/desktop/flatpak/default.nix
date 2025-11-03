# home.nix
{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
{

  imports = [ inputs.nix-flatpak.homeManagerModules.nix-flatpak ];

  # nix-flatpak setup
  #home.packages = with pkgs; [ flatpak ];
  #services.flatpak.enable = true;

  #Uncomment if you want to use both std and beta flathub repo
  # in this case you have to specify the origin form which install the app
  # see for example brave below
  services.flatpak.remotes = lib.mkOptionDefault [
    {
      name = "flathub-beta";
      location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
    }
  ];

  services.flatpak.update.auto.enable = false;
  services.flatpak.uninstallUnmanaged = false;
  services.flatpak.packages = [
    #{ appId = "com.brave.Browser"; origin = "flathub"; }
    "md.obsidian.Obsidian"
    #"im.riot.Riot"
  ];

  xdg.systemDirs.data = [
    "/var/lib/flatpak/exports/share"
    "/home/${config.home.username}/.local/share/flatpak/exports/share"
  ];
}
