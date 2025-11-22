{

  flake.modules.nixos.docker =

    {
      virtualisation.docker = {
        enable = true;
      };

      custom.imp.root.directories = [ "/var/lib/docker" ];

    };
}
