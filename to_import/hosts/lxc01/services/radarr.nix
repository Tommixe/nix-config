{ config, ... }:
{
  services.radarr = {
    enable = true;
    openFirewall = true;
  };

  environment.persistence = {
    "/persist".directories = [
      "/var/lib/radarr"
    ];
  };

}
