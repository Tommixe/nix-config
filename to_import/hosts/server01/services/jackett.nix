{ config, ... }:
{
  services.jackett = {
    enable = true;
    dataDir = "/srv/multimedia/jackett";
    openFirewall = true;
  };
}
