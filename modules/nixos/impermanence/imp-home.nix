# This file defines the "non-hardware dependent" part of opt-in persistence
# It imports impermanence, defines the basic persisted dirs, and ensures each
# users' home persist dir exists and has the right permissions
#
# It works even if / is tmpfs, btrfs snapshot, or even not ephemeral at all.
#https://github.com/Ladas552/Flake-Ocean/blob/master/modules/nixosModules/Impermanence/imp.nix
{
  flake.modules.homeManager.imp-home =
    {
      inputs,
      lib,
      config,
      ...
    }:
    let
      #cfg = config.custom.imp;
      userName = config.home.username; #"tommaso";
      cfghm = config.custom.imp;
      #cfghj = config.hjem.users."ladas552".custom.imp;
    in
    {
      imports = [ inputs.impermanence.homeManagerModules.impermanence ];

      home.persistence = {
        "/persist/home/${userName}" = {
          allowOther = true;
          directories = lib.unique (
            [

            ]
            ++ cfghm.home.directories
          );
        };
      };

    };
}
