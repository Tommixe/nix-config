#https://github.com/atropos112/nixos/blob/main/modules/garage.nix
#https://github.com/atropos112/nixos/blob/main/profiles/services/garage.nix

#https://github.com/awlsring/nix-config/blob/main/modules/system/linux/services/garage.nix

{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.services.garage-s3;

  settings = {
    data_dir = [
      {
        capacity = cfg.data.capacity;
        path = cfg.data.dir; # Where data lives (need high capacity)
      }
    ];
    metadata_dir = cfg.metadataDir; # Where metadata lives (need high speed)
    db_engine = "sqlite"; # Database engine

    replication_factor = 1; # Number of copies of data

    node_name = cfg.node_name;

    rpc_bind_addr = "[::]:3901";
    rpc_public_addr = cfg.rpcPublicAddr;
    rpc_secret_file = config.sops.secrets."${cfg.secrets.rpcSecret}".path;

    s3_api = {
      s3_region = "garage";
      api_bind_addr = "[::]:3900";
      root_domain = ".s3.garage.localhost";
    };
    s3_web = {
      bind_addr = "[::]:3902";
      index = "index.html";
      root_domain = ".web.garage.localhost";
    };

    k2v_api = {
      api_bind_addr = "[::]:3904";
    };

    admin = {
      api_bind_addr = "[::]:3903";
      admin_token_file = config.sops.secrets."${cfg.secrets.adminToken}".path;
      # Do not need token on metrics endpoint
      # metrics_token_file = "nope";
    };
  };
in {
  options.services.garage-s3 = {
    enable = mkEnableOption "Enable Garage service";
    data = {
      dir = mkOption {
        type = types.str;
        description = "Directory where Garage stores its metadata";
      };
      capacity = mkOption {
        type = types.str;
        description = "Capacity of the Garage data directory";
      };
    };
    metadataDir = mkOption {
      type = types.str;
      description = "Directory where Garage stores its metadata";
    };
    package = mkOption {
      type = types.package;
      default = pkgs.garage_2;
      description = "Garage package to use";
    };
    rpcPublicAddr = mkOption {
      type = types.str;
    };
    node_name = mkOption {
      type = types.str;
      description = "S3 node name";
      default = "garage";
    };
    secrets = {
      sopsFile = mkOption {
        type = types.str;
        description = "Path of the secrets.yaml file";
      };
      rpcSecret = mkOption {
        type = types.str;
        description = "Path to the RPC secret file";
      };
      adminToken = mkOption {
        type = types.str;
        description = "Path to the admin token file";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
    ];


    # open firewall ports
    networking.firewall.allowedTCPPorts = [ 3900 3901 ];

    #https://nixos.wiki/wiki/Nix_Language:_Tips_&_Tricks
    sops.secrets = {
      "${cfg.secrets.rpcSecret}" = {
        sopsFile = ./${cfg.secrets.sopsFile};
      };
      "${cfg.secrets.adminToken}" = {
        sopsFile =  ./${cfg.secrets.sopsFile};
      };
    };
    # Can't use dynamic user with secrets above
    # because dynamic user is not allowed to read secrets
    systemd.services.garage.serviceConfig = {
      DynamicUser = false;
      ProtectHome = lib.mkForce false;
    };

    services.garage = {
      enable = true;
      inherit settings;
      package = cfg.package;
      # debug is nice but it's a bit too verbose
      logLevel = "info";
    };
  };
}