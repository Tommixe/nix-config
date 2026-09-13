{ config, ... }:
{
  flake.modules.homeManager.base = {
    imports =
      # Import the nixos base modules for all nixos hosts.
      # it is imported in all nixosConfigurations by flake-parts/host.nix 
      with config.flake.modules.homeManager; [
        # Modules
        bash
        bat
        cli-pkgs
        direnv
        fish
        gh
        git
        hm
        starship
        ssh
      ];
  };
}
