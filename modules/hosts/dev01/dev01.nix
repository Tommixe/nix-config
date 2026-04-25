{ config, ... }:
{
  nixosHosts.dev01 = {
    unstable = false;
    modules = [ ];
  };

  flake.modules.nixos.host_dev01 = {
    imports = with config.flake.modules.nixos; [
      fail2ban
      ephemeral-btrfs
      docker
      portainer
      sops
      imp
      imp-options
      pii
      auto-upgrade
    ];

    networking = {
      hostName = "dev01";
      useDHCP = true;
    };

    nixpkgs.config.allowUnfree = true;

    system.stateVersion = "23.05";
  };
}
