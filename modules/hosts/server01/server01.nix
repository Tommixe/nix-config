{ config, ... }:
{
  nixosHosts.server01 = {
    unstable = false;
    modules = [ ];
  };

  flake.modules.nixos.host_server01 = {
    imports = with config.flake.modules.nixos; [
      fail2ban
      ephemeral-btrfs
      docker
      portainer
      dockge
      gh-token
      duplicacy
      msmtp
      tailscale-server-local # auto-imports sops; expects secrets.yaml with tailscale-authkey-file
      jellyfin
      sonarr
      radarr
      jackett
      transmission
      sops
      imp
      imp-options
      pii
      auto-upgrade
    ];

    networking = {
      hostName = "server01";
      useDHCP = true;
    };

    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.permittedInsecurePackages = [
      "openssl-1.1.1u"
      "dotnet-runtime-wrapped-6.0.36"
      "aspnetcore-runtime-6.0.36"
      "aspnetcore-runtime-wrapped-6.0.36"
      "dotnet-sdk-6.0.428"
      "dotnet-sdk-wrapped-6.0.428"
      "dotnet-runtime-6.0.36"
    ];

    users.groups.www-data = {
      gid = 33;
      members = [
        "radarr"
        "sonarr"
        "jellyfin"
        "transmission"
      ];
    };

    # homepage / homepage-docker services omitted: had broken sops paths
    # referencing ../common/secrets.yaml — needs re-implementation.

    system.stateVersion = "23.05";
  };
}
