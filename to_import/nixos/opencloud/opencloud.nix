# https://github.com/opencloud-eu/opencloud/blob/main/deployments/examples/opencloud_full/keycloak.yml
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.modules.opencloud;
 
  containerBackendName = config.virtualisation.oci-containers.backend;
  containerBackend = pkgs."${containerBackendName}" + "/bin/" + containerBackendName;
in
{
   imports = [ inputs.quadlet-nix.nixosModules.quadlet ];

  options.modules.opencloud = with lib.types; {
    enable = lib.mkEnableOption "OpenCloud, Nextcloud but without bloat";

    openFirewall = lib.mkEnableOption "Open the required ports in the firewall";

    port = lib.mkOption {
      type = types.port;
      default = 9200;
      description = "The port to use";
    };

    configDir = lib.mkOption {
      type = lib.types.str;
      description = "Path to the config file";
    };

    dataDir = lib.mkOption {
      type = types.str;
      description = "Path to where the data will be stored";
    };

    version = lib.mkOption {
      type = lib.types.str;
      default = "2.0.4";
      description = "Open cloud docker image verions number i.e. 2.0.4";
    };
    
    S3_access_key = lib.mkOption {
      type = types.str;
      description = "S3 access key";
    };

    S3_bucket = lib.mkOption {
      type = types.str;
      description = "S3 bucket";
    };

    S3_endpoint = lib.mkOption {
      type = types.str;
      description = "S3 endpoint";
    };
    
    S3_region = lib.mkOption {
      type = types.str;
      description = "S3 region";
    };

    S3_secret_key = lib.mkOption {
      type = types.str;
      description = "S3 secret key";
    };

    environmentFiles = lib.mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "List of environment files to pass for secrets, oidc and others";
    };

    domain = lib.mkOption {
      type = types.str;
      description = "URL of the Opencloud instance, needs to be https and the same as the OpenIDConnect proxy";
    };
  };

  config = lib.mkIf cfg.enable {

    #imports = [ inputs.quadlet-nix.nixosModules.quadlet ];

    virtualisation.quadlet =
    let
      inherit (config.virtualisation.quadlet) networks;
    in
    {

      autoEscape = true;
      networks.opencloud.networkConfig = {
        driver = "bridge";
        podmanArgs = [ "--interface-name=opencloud" ];
      };

      containers = {
        opencloud-server = {
          containerConfig = {
            image = "opencloudeu/opencloud:${cfg.version}";
            publishPorts = [
              "${toString cfg.port}:9200" 
            ];
            volumes = [
              "/etc/localtime:/etc/localtime:ro"
              "${cfg.configDir}:/etc/opencloud"
              "${./csp.yaml}:/etc/opencloud/csp.yaml"
              "${./proxy.yaml}:/etc/opencloud/proxy.yaml"
              "${./app-registry.yaml}:/etc/opencloud/app-registry.yaml"
              "${cfg.dataDir}:/var/lib/opencloud"
            ];
            environmentFiles = cfg.environmentFiles ;
            environments = {
              IDM_CREATE_DEMO_USERS = "false";

              PROXY_TLS = "false";
              PROXY_HTTP_ADDR = "0.0.0.0:9200";
              START_ADDITIONAL_SERVICES = "notifications";

              OC_INSECURE = "false";
              OC_URL = "https://${cfg.domain}";
              OC_LOG_LEVEL = "info";

              #STORAGE_USERS_POSIX_WATCH_FS = "true";
              GATEWAY_GRPC_ADDR = "0.0.0.0:9142";
              MICRO_REGISTRY_ADDRESS = "127.0.0.1:9233";
              NATS_NATS_HOST = "0.0.0.0";
              NATS_NATS_PORT = "9233";
            
              STORAGE_USERS_DRIVER = "decomposeds3";
              # keep system data on opencloud storage since this are only small files atm
              STORAGE_SYSTEM_DRIVER = "decomposed";
              # decomposeds3 specific settings
              STORAGE_USERS_DECOMPOSEDS3_ENDPOINT = "https://${cfg.S3_endpoint}";
              STORAGE_USERS_DECOMPOSEDS3_REGION = "${cfg.S3_region}";
              STORAGE_USERS_DECOMPOSEDS3_ACCESS_KEY = "${cfg.S3_access_key}";
              STORAGE_USERS_DECOMPOSEDS3_SECRET_KEY = "${cfg.S3_secret_key}";
              STORAGE_USERS_DECOMPOSEDS3_BUCKET =  "${cfg.S3_bucket}";

              #Tika
              SEARCH_EXTRACTOR_TYPE = "tika";
              SEARCH_EXTRACTOR_TIKA_TIKA_URL = "http://opencloud-tika:9998";
              FRONTEND_FULL_TEXT_SEARCH_ENABLED = "true";
            };
            entrypoint = "/bin/sh";
            exec = [
              "-c"
              "opencloud init | true; opencloud server"
            ];
            networks = [ networks.opencloud.ref ];
          };
          serviceConfig = {
            Restart = "always";
          };
        };

        opencloud-tika = {
          containerConfig = {
            image = "apache/tika:3.2.1.0-full";
            networks = [ networks.opencloud.ref ];
          };
          serviceConfig = {
            Restart = "always";
          };
        };
      };
    };

    services.nginx.virtualHosts."${cfg.domain}" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
        proxyPass = "http://127.0.0.1:${toString cfg.port}";
        #proxyWebsockets = true;
        };
    };

    # Expose ports for container
    networking.firewall = lib.mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port ]; };

    systemd.tmpfiles.settings.opencloud = {
      "${cfg.dataDir}" = {
        d = {
          mode = "0777";
          user = "root";
        };
      };
      "${cfg.configDir}" = {
        d = {
          mode = "0777";
          user = "root";
        };
      };
    };


  };
}