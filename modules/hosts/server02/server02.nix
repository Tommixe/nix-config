{ config, lib, ... }:
{
  nixosHosts.server02 = {
    unstable = false;
    modules = [ ];
  };

  flake.modules.nixos.host_server02 = {
    imports = with config.flake.modules.nixos; [
      fail2ban
      ephemeral-btrfs
      docker
      dockge
      gh-token
      sops # explicit: gh-token uses sops.secrets but doesn't auto-import sops
      imp
      imp-options
      pii
      auto-upgrade
    ];

    networking = {
      hostName = "server02";
      useDHCP = lib.mkDefault true;
      # NOTE: Static IP via sops cat-string (ip-server02) was broken in old config.
      # Re-add with literal IP if static addressing is needed.
    };

    nixpkgs.config.allowUnfree = true;

    # TODO: kasm — was partially active (persistence dirs + firewall, no service).
    # No kasm optional module exists. When ready, either create
    # modules/nixos/optional/kasm.nix or add inline:
    #   services.kasmweb.enable = true;
    #   environment.persistence."/persist".directories = [ "/srv/kasm" "/srv/kasmprofiles" ];
    #   networking.firewall.allowedTCPPorts = [ 3000 443 ];
    #   networking.firewall.allowedUDPPorts = [ 3000 443 ];

    system.stateVersion = "23.11";
  };
}
