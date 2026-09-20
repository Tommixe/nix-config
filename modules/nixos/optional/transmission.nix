{

  flake.modules.nixos.transmission =
    { pkgs, ... }:
    {

      services.transmission = {

        enable = true;

        package = pkgs.transmission_4;

        settings.watch-dir = "/data/torrents/watch";

        settings.watch-dir-enabled = true;

        settings.incomplete-dir = "/data/torrents/downloading";

        settings.download-dir = "/data/torrents/completed";

        settings.incomplete-dir-enabled = true;

        settings.rpc-enabled = true;

        settings.peer-port = 51413;

        settings.rpc-authentication-required = false;

        settings.rpc-bind-address = "0.0.0.0";

        settings.rpc-host-whitelist-enabled = false;

        settings.rpc-whitelist-enabled = false;

        openFirewall = true;

        settings = {
          seed_ratio_limited = true;
          seed_ratio_limit = 2.0;
        };

      };

      networking.firewall.allowedTCPPorts = [

        9091

        51413

      ];

      networking.firewall.allowedUDPPorts = [ 51413 ];

    };

}
