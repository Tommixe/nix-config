{ config, ... }:
{
  services.transmission = {
    enable = true;
    # home = "/srv/multimedia/transmission";
    settings.watch-dir = "/srv/multimedia/torrents/watch";
    settings.watch-dir-enabled = true;
    settings.incomplete-dir = "/srv/multimedia/torrents/downloading";
    settings.download-dir = "/srv/multimedia/torrents/completed";
    settings.incomplete-dir-enabled = true;
    settings.rpc-enabled = true;
    settings.peer-port = 51413;
    settings.rpc-authentication-required = false;
    settings.rpc-bind-address = "0.0.0.0";
    settings.rpc-host-whitelist-enabled = false;
    settings.rpc-whitelist-enabled = false;
    openFirewall = true; # Forward listen ports
  };

  systemd.services.transmission = {
    wants = [ "srv-multimedia.mount" ];
    after = [ "srv-multimedia.mount" ];
  };

  networking.firewall.allowedTCPPorts = [
    9091
    51413
  ];
  networking.firewall.allowedUDPPorts = [ 51413 ];
}
