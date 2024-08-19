{ config, pkgs, ... }:
{
  config.virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      dockge = {
        image = "louislam/dockge:latest";
        ports = [ "5001:5001" ];
        autoStart = true;
        #extraOptions = ["--restart=always"];
        volumes = [
          "/var/run/docker.sock:/var/run/docker.sock"
          "/srv/dockge_data:/app/data"
          "/srv/stacks:/srv/stacks"
        ];
        environment = {
          DOCKGE_STACKS_DIR = "/srv/stacks";
        };
      };
    };
  };

  config.environment.persistence = {
    "/persist".directories = [
      "/srv/dockge_data"
      "/srv/stacks"
    ];
  };

  config.networking.firewall = {
    allowedTCPPorts = [ 5001 ];
    allowedUDPPorts = [ 5001 ];
  };
}
