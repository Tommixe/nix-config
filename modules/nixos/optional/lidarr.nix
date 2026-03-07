{

  flake.modules.nixos.lidarr =

    {

      services.lidarr = {
        enable = true;
        openFirewall = true;
      };

      custom.imp.root.directories = [
        "/var/lib/lidarr"
      ];

    };

}
