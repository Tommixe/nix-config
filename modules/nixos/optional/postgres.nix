{
  flake.modules.nixos.postgres = {
    services.postgresql.enable = true;

    custom.imp.root.directories = [ "/var/lib/postgresql" ];

  };
}
