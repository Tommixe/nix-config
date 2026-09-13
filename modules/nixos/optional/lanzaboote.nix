{
  flake.modules.nixos.lanzaboote =
    { inputs, lib, ... }:
    {
      imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

      # lanzaboote takes over from systemd-boot
      boot.loader.systemd-boot.enable = lib.mkForce false;

      boot.lanzaboote = {
        enable = true;
        # sbctl stores keys here; must survive reboots on ephemeral-root hosts
        pkiBundle = "/etc/secureboot";
      };

      # Persist secureboot keys across ephemeral-root wipes
      custom.imp.root.directories = [ "/etc/secureboot" ];
    };
}
