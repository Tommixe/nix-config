{ config, ... }:
{
  services.sonarr = {
    enable = true;
    dataDir = "/srv/multimedia/sonarr";
    openFirewall = true;
  };
}
