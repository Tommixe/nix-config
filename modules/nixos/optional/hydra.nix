{

  flake.modules.nixos.hydra =

    {
    
      config,       
      ...
    }:
    let
      hydraUser = config.users.users.hydra.name;
      hydraGroup = config.users.users.hydra.group;
      tokenGroup = config.users.groups.nix-access-tokens.name;
    in
    {
      #imports = [ config.self.modules.hydra-machines ];

      # https://github.com/NixOS/nix/issues/5039
      nix.extraOptions = ''
        allowed-uris = https:// http:// github: git+https://github.com/ git+https://github.com/ gitlab:
        tarball-ttl = 0
      '';
      # https://github.com/NixOS/nix/issues/4178#issuecomment-738886808
      systemd.services.hydra-evaluator.environment.GC_DONT_GC = "true";

      services = {
        hydra = {
          enable = true;
          #hydraURL = "https://hydracloud.tzero.it";
          notificationSender = config.global-var.user01-email01;
          listenHost = "localhost";
          smtpHost = "localhost";
          useSubstitutes = true;
          extraConfig = # xml
            ''
              Include ${config.sops.secrets.hydra-gh-auth.path}
              allow_import_from_derivation = true
              max_unsupported_time = 30
            '';
          extraEnv = {
            HYDRA_DISALLOW_UNFREE = "0";
          };
        };
        

      };
      users.users = {
        hydra.extraGroups = [ tokenGroup ];
        hydra-queue-runner.extraGroups = [
          hydraGroup
          tokenGroup
        ];
        hydra-www.extraGroups = [
          hydraGroup
          tokenGroup
        ];
      };

      systemd.services.hydra-evaluator.serviceConfig.SupplementaryGroups = [ tokenGroup ];
      systemd.services.hydra-queue-runner.serviceConfig.SupplementaryGroups = [
        tokenGroup
        #config.users.groups.hydra-builder-client.name
      ];

      sops.secrets = {
        hydra-gh-auth = {
          sopsFile = ../../hosts/${config.networking.hostName}/secrets.yaml;
          owner = hydraUser;
          group = hydraGroup;
          mode = "0440";
        };
        nix-ssh-key = {
          sopsFile = ../../hosts/${config.networking.hostName}/secrets.yaml;
          owner = hydraUser;
          group = hydraGroup;
          mode = "0440";
        };
      };


      custom.imp.root.directories = [ "/var/lib/hydra" ];


    };

}
