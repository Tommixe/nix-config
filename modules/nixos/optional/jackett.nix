{

  flake.modules.nixos.jackett =

    { pkgs, ... }:

    {

      services.jackett = {

        enable = true;

        openFirewall = true;

        package = pkgs.jackett.overrideAttrs { doCheck = false; }; 

      };



      custom.imp.root.directories = [

        "/var/lib/jackett"

      ];

    };

}