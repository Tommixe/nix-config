{

  flake.modules.nixos.radarr =

    { config, ... }:

    {

      services.radarr = {

        enable = true;

        openFirewall = true;

      };



      custom.imp.root.directories = [

        "/var/lib/radarr"

      ];

    };

}