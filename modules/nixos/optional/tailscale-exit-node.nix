{
  flake.modules.nixos.tailscale-exit-node =
    { inputs, ... }:
    {
      imports = [ inputs.self.modules.nixos.tailscale ];
      
      services.tailscale = {
        useRoutingFeatures = "both";
      };
    };
}
