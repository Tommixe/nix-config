{
  inputs,
  lib,
  config,
  ...
}:
{
  nix = {
    settings = {
      #substituters = [
      #  "https://cache.m7.rs"
      #];
      #trusted-public-keys = [
      #  "cache.m7.rs:kszZ/NSwE/TjhOcPPQ16IuUiuRSisdiIwhKZCxguaWg="
      #];
      trusted-users = [
        "root"
        "@wheel"
      ];
      auto-optimise-store = lib.mkDefault true;
      experimental-features = [
        "nix-command"
        "flakes"
        "repl-flake"
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

    gc = {
      automatic = true;
      dates = "weekly";
      # Delete older generations too
      options = "--delete-older-than 2d";
    };

    # Add each flake input as a registry
    # To make nix3 commands consistent with the flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # Add nixpkgs input to NIX_PATH
    # This lets nix2 commands still use <nixpkgs>
    nixPath = [ "nixpkgs=${inputs.nixpkgs.outPath}" ];
  };

  /*
    sops.secrets = {
      github-token= {
        sopsFile = ../secrets.yaml;
      };
    };
  */
}
