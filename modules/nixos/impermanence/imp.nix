# This file defines the "non-hardware dependent" part of opt-in persistence
# It imports impermanence, defines the basic persisted dirs, and ensures each
# users' home persist dir exists and has the right permissions
#
# It works even if / is tmpfs, btrfs snapshot, or even not ephemeral at all.
#https://github.com/Ladas552/Flake-Ocean/blob/master/modules/nixosModules/Impermanence/imp.nix
{
  flake.modules.nixos.imp =
    {
      inputs,
      lib,
      config,
      ...
    }:
    let
      cfg = config.custom.imp;
    in
    {
      imports = [ inputs.impermanence.nixosModules.impermanence ];

      environment.persistence = {
        "/persist" = {
          hideMounts = true;
          directories = lib.unique (
            [
              "/var/lib/systemd"
              "/var/lib/nixos"
              "/var/log"
              "/srv"
              "/var/lib/nfs"
              "/var/lib/bluetooth"
            ]
            ++ cfg.root.directories
          );
        };
      };

      
      programs.fuse.userAllowOther = true;

      system.activationScripts.persistent-dirs.text =
        let
          mkHomePersist =
            user:
            lib.optionalString user.createHome ''
              mkdir -p /persist/${user.home}
              chown ${user.name}:${user.group} /persist/${user.home}
              chmod ${user.homeMode} /persist/${user.home}
            '';
          users = lib.attrValues config.users.users;
        in
        lib.concatLines (map mkHomePersist users);
    };
}
