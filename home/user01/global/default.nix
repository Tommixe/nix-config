{
  inputs,
  lib,
  pkgs,
  config,
  outputs,
  ...
}:
let
  inherit (inputs.nix-colors) colorSchemes;
  inherit (inputs.nix-colors.lib-contrib { inherit pkgs; })
    colorschemeFromPicture
    nixWallpaperFromScheme
    ;  
  username = "tommaso";  
in
{
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
    inputs.nix-colors.homeManagerModule
    ../../features/cli
    #../../features/desktop/gnome
    #../features/nvim
    #../features/helix
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
      # FIXME
      permittedInsecurePackages = [ "openssl-1.1.1u" ];
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

  systemd.user.startServices = "sd-switch";

  programs = {
    home-manager.enable = true;
    git.enable = true;
  };

  home = {
    username = "${username}";
    homeDirectory = lib.mkDefault "/home/${username}";
    stateVersion = lib.mkDefault "23.05";
    sessionPath = [ "$HOME/.local/bin" ];
    persistence."/persist/home/${username}".allowOther = true;
  };

  colorscheme = lib.mkDefault colorSchemes.dracula;
  wallpaper =
    let
      largest = f: xs: builtins.head (builtins.sort (a: b: a > b) (map f xs));
      largestWidth = largest (x: x.width) config.monitors;
      largestHeight = largest (x: x.height) config.monitors;
    in
    lib.mkDefault (nixWallpaperFromScheme {
      scheme = config.colorscheme;
      width = largestWidth;
      height = largestHeight;
      logoScale = 4;
    });
  home.file.".colorscheme".text = config.colorscheme.slug;
}
