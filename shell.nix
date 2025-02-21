{
  pkgs ? import <nixpkgs> { config.allowUnfree = true; },
  ...
}:
  pkgs.mkShell {
    NIX_CONFIG = "extra-experimental-features = nix-command flakes ca-derivations";
    packages = with pkgs; [
      nix
      home-manager
      git
      sops
      ssh-to-age
      gnupg
      age
      opentofu
      bws
    ];
}