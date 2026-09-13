{
  flake.modules.nixos.mysql =
    { pkgs, ... }:
    {
      services.mysql = {
        enable = true;
        package = pkgs.mariadb;
      };

      custom.imp.root.directories = [ "/var/lib/mysql" ];

    };
}
