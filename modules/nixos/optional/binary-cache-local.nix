{
  flake.modules.nixos.binary-cache-local =
    { config, inputs, ... }:
    {

      imports = [ inputs.self.modules.nixos.binary-cache ];


      services = {
        nginx.virtualHosts."cache.tzero.it" = {
          forceSSL = true;
          enableACME = true;
          locations."/".extraConfig = ''
            proxy_pass http://localhost:${toString config.services.nix-serve.port};
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          '';
        };
      };


    };
}
