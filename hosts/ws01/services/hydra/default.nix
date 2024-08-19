{
  pkgs,
  lib,
  config,
  outputs,
  inputs,
  ...
}:
let
  hydraUser = config.users.users.hydra.name;
  hydraGroup = config.users.users.hydra.group;
  tokenGroup = config.users.groups.nix-access-tokens.name;

  release-host-branch = pkgs.callPackage ./lib/release-host-branch.nix {
    sshKeyFile = config.sops.secrets.nix-ssh-key.path;
  };
in
{
  imports = [ ./machines.nix ];

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
      hydraURL = "https://hydra.tzero.it";
      notificationSender = "cat ${config.sops.secrets.user01-email01.path}";
      listenHost = "localhost";
      smtpHost = "localhost";
      useSubstitutes = true;
      extraConfig = # xml
        ''
          Include ${config.sops.secrets.hydra-gh-auth.path}
          max_unsupported_time = 30
          <runcommand>
            job = nix-config:main:*
            command = ${lib.getExe release-host-branch}
          </runcommand>
        '';
      extraEnv = {
        HYDRA_DISALLOW_UNFREE = "0";
      };
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
      sopsFile = ../../secrets.yaml;
      owner = hydraUser;
      group = hydraGroup;
      mode = "0440";
    };
    nix-ssh-key = {
      sopsFile = ../../secrets.yaml;
      owner = hydraUser;
      group = hydraGroup;
      mode = "0440";
    };
  };

  sops.secrets = {
    user01-email01 = {
      sopsFile = ../../../common/global/secrets.yaml;
    };
  };

  environment.persistence = {
    "/persist".directories = [ "/var/lib/hydra" ];
  };
}
