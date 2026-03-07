{

  flake.modules.nixos.jackett =

    { config, ... }:

    {

      services.jackett = {

        enable = true;

        openFirewall = true;

      };



      custom.imp.root.directories = [

        "/var/lib/jackett"

      ];

    };

}