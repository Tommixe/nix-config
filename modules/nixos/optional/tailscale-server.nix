{ config, ... }:
{
  flake.modules.nixos.tailscale-server = {
    
    imports = [ config.flake.modules.nixos.tailscale ];

    services.tailscale = {
      extraUpFlags = [
        "--ssh"
        "--accept-routes"
      ];
      authKeyFile = config.sops.secrets.tailscale-authkey-file.path;
    };

    sops.secrets.tailscale-authkey-file = {
      sopsFile = ../../hosts/${config.networking.hostName}/secrets.yaml;
    };
  };
}
