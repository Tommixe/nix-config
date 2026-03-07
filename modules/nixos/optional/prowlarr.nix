{

  flake.modules.nixos.prowlarr =

    {

      services.prowlarr = {
        enable = true;
        openFirewall = true;
      };

      custom.imp.root.directories = [
        "/var/lib/prowlarr"
      ];

    };

}
