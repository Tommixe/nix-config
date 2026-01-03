{ config, ... }:
{
  flake.modules.nixos.base = {
    imports =
      # Import the nixos base modules for all nixos hosts.
      # it is imported in all nixosConfigurations by flake-parts/host.nix 
      with config.flake.modules.nixos; [
        # Modules
        #auto-upgrade
        fish
        locale
        nh
        nix
        openssh
        tailscale
        zabbix-agent
      ];
  };
}
