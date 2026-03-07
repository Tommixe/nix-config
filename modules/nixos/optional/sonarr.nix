{

  flake.modules.nixos.sonarr =

    {

      services.sonarr = {

        enable = true;

        openFirewall = true;

      };

      custom.imp.root.directories = [

        "/var/lib/sonarr"

      ];

    };

}
