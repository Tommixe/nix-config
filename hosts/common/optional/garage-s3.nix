  { config, pkgs, ... }:
  {
  services.garage-s3 = {
    enable = true;
    package = pkgs.garage_2;
    secrets = {
      sopsFile = "./../../hosts/${config.networking.hostName}/secrets.yaml"; #path relative to nixos/modules/garage-s3.nix
      rpcSecret = "rpcSecret";
      adminToken = "adminToken";
    };
    data = {
        dir = "/persist/garage/data";
        capacity = "2G";
      };
    metadataDir = "/persist/garage/metadata";
    rpcPublicAddr = "hpx360:3901";
  };

  #environment.persistence = {
  #  "/persist".directories = [ "/var/lib/garage" ];
  #  };
  }