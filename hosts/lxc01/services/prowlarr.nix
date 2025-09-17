{ config, ... }:
{
  services.prowlarr = {
    enable = true;
    openFirewall = true;
  };

  environment.persistence = {
    "/persist".directories = [
      "/var/lib/prowlarr"
    ];
  };

}
