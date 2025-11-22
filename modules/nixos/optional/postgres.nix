{
  flake.modules.nixos.postgresql = {
    services.postgresql.enable = true;

    custom.imp.root.directories = [ "/var/lib/postgresql" ];

  };
}
