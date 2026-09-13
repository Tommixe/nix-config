{

  flake.modules.nixos.jellyfin =

    {

      services.jellyfin = {
        enable = true;
        openFirewall = true;
      };

      custom.imp.root.directories = [
        "/var/lib/jellyfin"
        "/var/cache/jellyfin"
      ];

    };

}
