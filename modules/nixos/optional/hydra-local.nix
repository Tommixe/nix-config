{

  flake.modules.nixos.hydra-local =

    {

      config,
      inputs,
      ...
    }:
    {
      imports = [
        inputs.self.modules.nixos.hydra
       # inputs.self.modules.nixos.nginx
      ];

      services = {
        hydra = {
          hydraURL = "https://ws02hydra.tzero.it";
        };
        listenHost = "0.0.0.0";
      };

      networking.firewall.allowedTCPPorts = [ 3000 ];

        # nginx.virtualHosts = {
        #   "ws02hydra.tzero.it" = {
        #     forceSSL = true;
        #     enableACME = true;
        #     locations = {
        #       #"~* ^/shield/([^\\s]*)".return =
        #       #  "302 https://img.shields.io/endpoint?url=https://hydra.m7.rs/$1/shield";
        #       "/".proxyPass = "http://localhost:${toString config.services.hydra.port}";
        #       #"/".extraConfig = ''
        #       #  proxy_pass http://localhost:${toString config.services.hydra.port};
        #       #  proxy_set_header Host $host;
        #       #  proxy_set_header X-Real-IP $remote_addr;
        #       #  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        #       #'';
        #     };
        #   };
        #};

    };

}
