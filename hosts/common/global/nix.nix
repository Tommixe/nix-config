{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
in  
{
  nix = {
    settings = {
      extra-substituters = lib.mkAfter ["https://cachecloud.tzero.it"];
      extra-trusted-public-keys = [
        "cachecloud.tzero.it:0d35aEumDjIuR27iqi5FgnFPmM1ppRpsu43aQx6xcpM=" 
        "cache.tzero.it:C3XpjhEEHIEz9Ygh5ZjTlv7Gh4a0In09hY66hmssDls="
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
      auto-optimise-store = lib.mkDefault true;
      experimental-features = [
        "nix-command"
        "flakes"
        "ca-derivations"
      ];
      warn-dirty = false;
      #access-tokens = "github.com=$(cat ${config.sops.secrets.github-token.path})" ;
      system-features = [
        "kvm"
        "big-parallel"
        "nixos-test"
      ];
      flake-registry = ""; # Disable global flake registry
    };

    # extraOptions = ''
    # !include "${config.sops.secrets.github-token.path}"
    # '';

    extraOptions = ''
     plugin-files = ${pkgs.nix-plugins}/lib/nix/plugins
     extra-builtins-file = ${../../../nix/extra-builtins.nix}
     '';    

    gc = {
      automatic = lib.mkIf (!config.programs.nh.enable) true;
      dates = "weekly";
      # Delete older generations too
      options = "--delete-older-than 7d";
    };

    # Add each flake input as a registry and nix_path
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  /*
    sops.secrets = {
      github-token= {
        sopsFile = ../secrets.yaml;
      };
    };
  */
}
