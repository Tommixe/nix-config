{ config, ... }:
{
  services.sonarr = {
    enable = true;
    openFirewall = true;
  };

   environment.persistence = {
    "/persist".directories = [
      "/var/lib/sonarr"
    ];
  };

}
