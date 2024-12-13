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
in
{
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
    inputs.nix-colors.homeManagerModule
    ../../features/cli
    #../features/desktop/gnome
    #../features/nvim
    #../features/helix
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
      # FIXME
      #https://discourse.nixos.org/t/solved-sonarr-is-broken-in-24-11-unstable-aka-how-the-hell-do-i-use-nixpkgs-config-permittedinsecurepackages/56828/6
      permittedInsecurePackages = [ 
            "openssl-1.1.1u" 
            "dotnet-runtime-wrapped-6.0.36"
            "aspnetcore-runtime-6.0.36"
            "aspnetcore-runtime-wrapped-6.0.36"
            "dotnet-sdk-6.0.428"
            "dotnet-sdk-wrapped-6.0.428"
            "dotnet-runtime-6.0.36"
      ];
    };
  };

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "repl-flake"
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
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "23.05";
    sessionPath = [ "$HOME/.local/bin" ];
    persistence."/persist/home/${config.home.username}".allowOther = true;
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
