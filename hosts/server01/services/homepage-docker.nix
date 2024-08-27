{ config, ... }:

{
  virtualisation.oci-containers.containers.homepage = {
    image = "ghcr.io/gethomepage/homepage:latest";
    ports = [ "3000:3000" ];
    environment = {
      "PUID" = "1000";
      "PGID" = "1000";
    };
    volumes = [
      "/srv/docker-apps/homepage:/app/config"
      "/var/run/docker.sock:/var/run/docker.sock"
    ];
  };

  sops.secrets."homepage/service.yaml" = {
    sopsFile = ../secrets.yaml;
    owner = config.users.users.user01.name;
    group = config.users.users.user01.group;
    path = "/srv/docker-apps/homepage/service.yaml";
  };

  environment.persistence = {
    "/persist".directories = [ "/srv/docker-apps/homepage" ];
  };

}   