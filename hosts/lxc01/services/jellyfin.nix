{ config, lib, ... }:
{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  #systemd.services.jellyfin.serviceConfig.WorkingDirectory = lib.mkForce  "/srv/multimedia/jellyfin";
  #systemd.services.jellyfin.serviceConfig.ExecStart= lib.mkForce /nix/store/cvdjqr33zxi4ca2xr65sxf7ydgj8dqmd-jellyfin-10.8.11/bin/jellyfin --datadir /var/lib/jellyfin --cachedir /var/cache/jellyfin

  environment.persistence = {
    "/persist".directories = [
      "/var/lib/jellyfin"
      "/var/cache/jellyfin"
    ];
  };
}
