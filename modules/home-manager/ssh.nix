{
  flake.modules.homeManager.base =
    {
      outputs,
      lib,
      config,
      ...
    }:
    let
      hostnames = builtins.attrNames outputs.nixosConfigurations;
    in
    {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;


        matchBlocks."*" = {
          forwardAgent = false;
          addKeysToAgent = "no";
          compression = false;
          serverAliveInterval = 0;
          serverAliveCountMax = 3;
          hashKnownHosts = false;
          userKnownHostsFile = "~/.ssh/known_hosts";
          controlMaster = "no";
          controlPath = "~/.ssh/master-%r@%n:%p";
          controlPersist = "no";
        };

        /*
          matchBlocks = {
            net = {
              host = builtins.concatStringsSep " " hostnames;
              forwardAgent = true;
              remoteForwards = [{
                bind.address = ''/%d/.gnupg-sockets/S.gpg-agent'';
                host.address = ''/%d/.gnupg-sockets/S.gpg-agent.extra'';
              }];
            };
            trusted = lib.hm.dag.entryBefore [ "net" ] {
              host = "m7.rs *.m7.rs *.ts.m7.rs";
              forwardAgent = true;
            };
          };
        */
      };

      custom.imp.home.directories = [ ".ssh"];

    };
}
