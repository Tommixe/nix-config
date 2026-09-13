{

  flake.modules.nixos.hydra-machines =
    {
      config,
      lib,
      ...
    }:
    let
      mkBuildMachine =
        {
          uri ? null,
          systems ? null,
          sshKey ? null,
          maxJobs ? 1,
          speedFactor ? 1,
          supportedFeatures ? null,
          mandatoryFeatures ? null,
          publicHostKey ? null,
        }:
        let
          field =
            x:
            if (x == null || x == [ ] || x == "") then
              "-"
            else if (builtins.isInt x) then
              (builtins.toString x)
            else if (builtins.isList x) then
              (builtins.concatStringsSep "," x)
            else
              x;
        in
        ''
          ${field uri} ${field systems} ${field sshKey} ${field maxJobs} ${field speedFactor} ${field supportedFeatures} ${field mandatoryFeatures} ${field publicHostKey}
        '';
      mkBuildMachines =
        machines: builtins.toFile "machines" (lib.concatStringsSep "\n" (map mkBuildMachine machines));
    in
    {
      services.hydra.buildMachinesFiles = [
        (mkBuildMachines [
          {
            uri = "ssh://nix-ssh@ws02";
            systems = [
              "x86_64-linux"
              "i686-linux"
            ];
            sshKey = config.sops.secrets.nix-ssh-key.path;
            maxJobs = 4;
            speedFactor = 150;
            supportedFeatures = [
              "kvm"
              "big-parallel"
              "nixos-test"
            ];
          }
          {
            uri = "ssh://nix-ssh@ws01";
            systems = [
              "x86_64-linux"
              "i686-linux"
            ];
            sshKey = config.sops.secrets.nix-ssh-key.path;
            maxJobs = 4;
            speedFactor = 100;
            supportedFeatures = [
              "kvm"
              "big-parallel"
              "nixos-test"
            ];
          }
          {
            uri = "localhost";
            systems = [
              "aarch64-linux"
              "x86_64-linux"
              "i686-linux"
            ];
            maxJobs = 4;
            # This is the only builder marked as aarch64, so these builds will always
            # run here (regardless of speedFactor).
            # As for x86_64, this machine's factor is much lower than the others, so
            # these builds will only be picked up if the others are offline.
            speedFactor = 1;
            supportedFeatures = [
              "kvm"
              "big-parallel"
              "nixos-test"
            ];
          }
        ])
      ];
    };
}
