{

  flake.modules.nixos.gradient =

    {

      pkgs,
      inputs,
      config,
      ...
    }:
    {

      # Not need to import for unstable becuase already alnded in nixpkgs unstable channel, but for stable we need to import it from the flake inputs
      #imports = [ inputs.gradient.nixosModules.gradient ];

      services.gradient = {
        enable = true;
        domain = "gradient.tzero.it";
        secrets.jwtFile = config.sops.secrets.gradient-jwtFile.path;
        secrets.cryptFile = config.sops.secrets.gradient-cryptFile.path;
        postgres.enable = true;
        worker.enable = true;
        #port = 4000;
      };

      services.postgresql.package = pkgs.postgresql_18;

      networking.firewall.allowedTCPPorts = [ 3000 ]; #hydra runs on 4000, gradient runs on 3000

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
