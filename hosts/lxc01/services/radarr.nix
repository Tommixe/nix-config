{ config, ... }:
{
  services.radarr = {
    enable = true;
    dataDir = "/data/radarr";
    openFirewall = true;
    #group = "tommaso";
  };
}
