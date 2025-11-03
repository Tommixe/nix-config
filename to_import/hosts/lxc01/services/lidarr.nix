{ config, ... }:
{
  services.lidarr = {
    enable = true;
    openFirewall = true;
  };

  environment.persistence = {
    "/persist".directories = [
      "/var/lib/lidarr"
    ];
  };

}
