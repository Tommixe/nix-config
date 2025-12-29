{config, ...}:
{
  flake.modules.nixos.tailscale-exit-node = {
    imports = [ config.flake.modules.nixos.tailscale];
    services.tailscale = {
      useRoutingFeatures = "both";
    };
  };
}
