#Finally modify your global configuration to work with flake-parts:
{ inputs, lib, system, pkgs, ... }:
let
  useHomeManagerUnstable = pkgs.system == inputs.nixpkgs-unstable.legacyPackages.${system};
  homeManagerModule = if useHomeManagerUnstable
    then inputs.home-manager-unstable.nixosModules.home-manager
    else inputs.home-manager.nixosModules.home-manager;
in {
  imports = [
    homeManagerModule
    # ... rest of your imports
  ];
  
  # ... rest of your configuration
}