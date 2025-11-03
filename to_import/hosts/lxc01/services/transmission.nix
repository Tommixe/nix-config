{ config, ... }:
{
  services.transmission = {
    enable = true;
    # home = "/srv/multimedia/transmission";
    settings.watch-dir = "/data/torrents/watch";
    settings.watch-dir-enabled = true;
    settings.incomplete-dir = "/data/torrents/downloading";
    settings.download-dir = "/data/torrents/completed";
    settings.incomplete-dir-enabled = true;
    settings.rpc-enabled = true;
    settings.peer-port = 51413;
    settings.rpc-authentication-required = false;
    settings.rpc-bind-address = "0.0.0.0";
    settings.rpc-host-whitelist-enabled = false;
    settings.rpc-whitelist-enabled = false;
    openFirewall = true; # Forward listen ports
  };

  networking.firewall.allowedTCPPorts = [
    9091
    51413
  ];
  networking.firewall.allowedUDPPorts = [ 51413 ];
}
