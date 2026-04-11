{

  flake.modules.nixos.hydra-local =

    {
    
      config,
      inputs,      
      ...
    }:
    {
      imports = [ inputs.self.modules.nixos.hydra ];


      services = {
        hydra = {
          hydraURL = "https://ws02hydra.tzero.it";
        };
        nginx.virtualHosts = {
          "hydra.tzero.it" = {
            forceSSL = true;
            enableACME = true;
            locations = {
              #"~* ^/shield/([^\\s]*)".return =
              #  "302 https://img.shields.io/endpoint?url=https://hydra.m7.rs/$1/shield";
              "/".proxyPass = "http://localhost:${toString config.services.hydra.port}";
              #"/".extraConfig = ''
              #  proxy_pass http://localhost:${toString config.services.hydra.port};
              #  proxy_set_header Host $host;
              #  proxy_set_header X-Real-IP $remote_addr;
              #  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              #'';
            };
          };
        };

      };



    };

}
