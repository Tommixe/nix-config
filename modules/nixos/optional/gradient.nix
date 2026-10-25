{

  flake.modules.nixos.gradient =

    {

      pkgs,
      inputs,
      config,
      ...
    }:
    {

      imports = [ inputs.gradient.nixosModules.gradient ];

      services.gradient = {
        enable = true;
        domain = "gradient.tzero.it";
        secrets.jwtFile = config.sops.secrets.gradient-jwtFile.path;
        secrets.cryptFile = config.sops.secrets.gradient-cryptFile.path;
        postgres.enable = true;
        worker.enable = true;
        port = 4000;
      };

      services.postgresql.package = pkgs.postgresql_18;

      networking.firewall.allowedTCPPorts = [ 4000 ]; #hydra runs on 3000, set 4000 for gradient

      custom.imp.root.directories = [
        "/var/lib/gradient"
        "/var/lib/postgresql"
      ];

      sops.secrets = {
        gradient-jwtFile = {
          sopsFile = ../../hosts/${config.networking.hostName}/secrets.yaml;          
        };
        gradient-cryptFile = {
          sopsFile = ../../hosts/${config.networking.hostName}/secrets.yaml;
        };
      };

    };

}
