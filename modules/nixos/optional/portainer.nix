{
  flake.modules.nixos.portainer =
    {
      virtualisation.oci-containers = {
        backend = "docker";
        containers = {
          portainer = {
            image = "portainer/portainer-ce:latest";
            ports = [
              "8000:8000"
              "9443:9443"
            ];
            autoStart = true;
            #extraOptions = ["--restart=always"];
            volumes = [
              "/var/run/docker.sock:/var/run/docker.sock"
              "/srv/portainer_data:/data"
            ];
          };
        };
      };

      custom.imp.root.directories = [ "/srv/portainer_data" ];

      networking.firewall = {
        allowedTCPPorts = [
          8443
          80
        ];
        allowedUDPPorts = [
          8443
          80
        ];
      };
    };
}
