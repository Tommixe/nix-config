{ config, lib, ... }:
{
  nixosHosts.ws01 = {
    unstable = false;
    modules = [ ];
  };

  flake.modules.nixos.host_ws01 = {
    imports = with config.flake.modules.nixos; [
      fail2ban
      ephemeral-btrfs
      docker
      dockge
      gnome
      tailscale-server # auto-imports sops; expects secrets.yaml with tailscale-authkey-file
      gh-token
      sops
      imp
      imp-options
      pii
      auto-upgrade
    ];

    networking = {
      hostName = "ws01";
      useDHCP = lib.mkDefault true;
      # NOTE: Static IP block was commented out in old config.
      # Sops secrets ip-ws01, ip-router, ip-ottoserver are dropped (were only
      # used in the commented-out block).
    };

    nixpkgs.config.allowUnfree = true;

    networking.firewall.allowedTCPPorts = [ 3389 ];

    programs = {
       #adb.enable = true;
      dconf.enable = true;
      kdeconnect.enable = true;
    };

    # NOTE: services/hydra/ (hydra-local, postgres, nginx, acme, binary-cache-local)
    # was entirely commented out in the old services/default.nix. Not ported.
    # Re-enable via those optional modules when ready.

    system.stateVersion = "23.11";
  };
}
