{
  flake.modules.homeManager.ssh =
    #{
    #lib,
    #inputs,
    # ...
    #}:
    let
      #commenting since with 25.11 not needed anymore
      #usingStable = lib.version == inputs.nixpkgs.lib.version;

      ssh-options =
        # if usingStable then
        #   { enable = true; }
        # else
        {
          enable = true;

          enableDefaultConfig = false;

          settings."*" = {
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
        };

    in
    {

      programs.ssh = ssh-options;

      custom.imp.home.directories = [ ".ssh" ];

    };
}
