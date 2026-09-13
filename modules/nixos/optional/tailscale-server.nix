{
  flake.modules.nixos.tailscale-server =
    { inputs, config, ... }:
    {

      imports = [
        inputs.self.modules.nixos.tailscale
        inputs.self.modules.nixos.sops
      ];

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
