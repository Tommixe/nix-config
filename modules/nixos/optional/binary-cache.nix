{
  flake.modules.nixos.binary-cache =
    { config, pkgs, ... }:
    {

      services = {
        nix-serve = {
          enable = true;
          secretKeyFile = config.sops.secrets.cache-sig-key.path;
          package = pkgs.nix-serve;
        };
      };

      sops.secrets.cache-sig-key = {
        sopsFile = ../../hosts/${config.networking.hostName}/secrets.yaml;
      };

      systemd.services.nix-serve.environment.HOME = "/";

    };
}
