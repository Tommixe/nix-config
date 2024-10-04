{ config, ... }:
{
  services.sonarr = {
    enable = true;
    dataDir = "/data/sonarr";
    openFirewall = true;
  };
}
