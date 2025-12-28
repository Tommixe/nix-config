{inputs, ...}: {
  imports = [
    inputs.flake-parts.flakeModules.easyOverlay
  ];
  perSystem = {
    pkgs,
    ...
  }: {
    packages = {
      rstart = pkgs.callPackage ./rstart/_rstart.nix { };
      };
  };
}