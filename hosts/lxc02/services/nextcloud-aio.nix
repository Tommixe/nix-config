{ config, pkgs, ... }:
{
  config.virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      nextcloud-aio-mastercontainer = {
        image = "nextcloud/all-in-one:latest";
        ports = [ 
          "80:80" 
          "8080:8080"
          "8443:8443"
        ];
        autoStart = true;
        #extraOptions = ["--restart=always"];
        volumes = [
          "nextcloud_aio_mastercontainer:/mnt/docker-aio-config"
          "/var/run/docker.sock:/var/run/docker.sock:ro"
        ];
        environment = {
          APACHE_PORT = "11000";
          APACHE_IP_BINDING= "0.0.0.0" ;
          NEXTCLOUD_DATADIR= "/nextcloud" ;
        };
      };
    };
  };


}
