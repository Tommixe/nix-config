{ config, ... }:
{
  flake.modules.nixos.base = {
    imports =
      # Import the nixos base modules for all nixos hosts.
      with config.flake.modules.nixos; [
        # Modules
        #auto-upgrade
        fish
        locale
        nh
        nix
        openssh
        tailscale
        systemd-initrd
        zabbix-agent
      ];
  };
}
