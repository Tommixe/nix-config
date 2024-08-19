{ config, ... }:
{
  services.radarr = {
    enable = true;
    dataDir = "/srv/multimedia/radarr";
    openFirewall = true;
    group = "tommaso";
  };
}
