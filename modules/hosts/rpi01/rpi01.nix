{ config, ... }:
{
  nixosHosts.rpi01 = {
    unstable = false;
    system = "aarch64-linux";
    modules = [ ];
  };

  flake.modules.nixos.host_rpi01 = {
    imports = with config.flake.modules.nixos; [
      ephemeral-btrfs
      wirelesspersist
      tailscale-server # auto-imports sops; expects secrets.yaml with tailscale-authkey-file
      imp
      imp-options
      pii
      auto-upgrade
    ];

    networking = {
      hostName = "rpi01";
      useDHCP = true;
      # NOTE: old config used broken `address = "cat ${sops-secret-path}"` pattern.
      # Static IP dropped; re-add with literal IP when needed.
    };

    nixpkgs.config.allowUnfree = true;

    system.stateVersion = "24.05";
  };
}
