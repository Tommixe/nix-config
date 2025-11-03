{ config, ... }:
{
  # https://github.com/tailscale/tailscale/issues/1227
  # Because of the issue above if the server is in the local lan
  # it is not reachable from other within the lan but outside tailscale
  # we need to remove --accept-routes flag to avoid lan traffic to be routed
  # in the tailscale advertised subnet routes
  
  imports = [ ../global/tailscale.nix ];

  services.tailscale = {
    extraUpFlags = [
      "--ssh"
    ];
    authKeyFile = config.sops.secrets.tailscale-authkey-file.path;
  };

  sops.secrets.tailscale-authkey-file = {
    sopsFile = ../../../hosts/${config.networking.hostName}/secrets.yaml;
  };
}
