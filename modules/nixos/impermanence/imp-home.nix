# This file defines the "non-hardware dependent" part of opt-in persistence
# It imports impermanence, defines the basic persisted dirs, and ensures each
# users' home persist dir exists and has the right permissions
#
# It works even if / is tmpfs, btrfs snapshot, or even not ephemeral at all.
#https://github.com/Ladas552/Flake-Ocean/blob/master/modules/nixosModules/Impermanence/imp.nix
{
  flake.modules.homeManager.imp-home =
    {
      lib,
      config,
      ...
    }:
    let
      cfghm = config.custom.imp;
    in
    {

      # https://github.com/nix-community/impermanence/issues/292
      # Home-manager persistence option can be used only with nixos hosts.
      home = lib.optionalAttrs (builtins.hasAttr "persistence" config.home ) {
        persistence = {
          "/persist" = {
            directories = lib.unique (
              [

              ]
              ++ cfghm.home.directories
            );
          };
        };
      };
    };
}
