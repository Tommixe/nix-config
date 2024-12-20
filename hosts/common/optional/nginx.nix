{ lib, config, pkgs, ... }:
let
  inherit (config.networking) hostName;
  realIpsFromList = lib.strings.concatMapStringsSep "\n" (x: "set_real_ip_from  ${x};");
  fileToList = x: lib.strings.splitString "\n" (builtins.readFile x);
  cfipv4 = fileToList (pkgs.fetchurl {
            url = "https://www.cloudflare.com/ips-v4";
            hash = "sha256-8Cxtg7wBqwroV3Fg4DbXAMdFU1m84FTfiE5dfZ5Onns=";
          });
 cfipv6 = fileToList (pkgs.fetchurl {
            url = "https://www.cloudflare.com/ips-v6";
            hash = "sha256-np054+g7rQDE3sr9U8Y/piAp89ldto3pN9K+KCNMoKk=";
          });
in
{
  services = {
    nginx = {
      enable = true;
      recommendedTlsSettings = true;
      recommendedProxySettings = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      clientMaxBodySize = "300m";
      commonHttpConfig =
        ''
          ${realIpsFromList cfipv4}
          ${realIpsFromList cfipv6}
          real_ip_header CF-Connecting-IP;
        '';


      /*
        virtualHosts."${hostName}.tzero.it" = {
          default = true;
          forceSSL = true;
          enableACME = true;
          locations."/metrics" = {
            proxyPass = "http://localhost:${toString config.services.prometheus.exporters.nginxlog.port}";
          };
        };
      */

    };

    /*
      prometheus.exporters.nginxlog = {
        enable = true;
        group = "nginx";
        settings.namespaces = [{
          name = "filelogger";
          source.files = [ "/var/log/nginx/access.log" ];
          format = "$remote_addr - $remote_user [$time_local] \"$request\" $status $body_bytes_sent \"$http_referer\" \"$http_user_agent\"";
        }];
      };
    */

    uwsgi = {
      enable = true;
      user = "nginx";
      group = "nginx";
      plugins = [ "cgi" ];
      instance = {
        type = "emperor";
        vassals = lib.mkBefore { };
      };
    };
  };
  
  # networking.firewall.allowedTCPPorts = [
  #   80
  #   443
  # ];

  # Block non-Cloudflare IP addresses.
    networking.firewall = let
      chain = "cloudflare-whitelist";
    in {
      extraCommands = let
        allow-interface = lib.strings.concatMapStringsSep "\n" (i: ''ip46tables --append ${chain} --in-interface ${i} --jump RETURN'');
        allow-ip = cmd: lib.strings.concatMapStringsSep "\n" (r: ''${cmd} --append ${chain} --source ${r} --jump RETURN'');
      in ''
        # Flush the old firewall rules. This behavior mirrors the default firewall service.
        # See: https://github.com/NixOS/nixpkgs/blob/ac911bf685eecc17c2df5b21bdf32678b9f88c92/nixos/modules/services/networking/firewall-iptables.nix#L59-L66
        ip46tables --delete INPUT --protocol tcp --destination-port 80  --syn --jump ${chain} 2>/dev/null || true
        ip46tables --delete INPUT --protocol tcp --destination-port 443 --syn --jump ${chain} 2>/dev/null || true
        ip46tables --flush ${chain} || true
        ip46tables --delete-chain ${chain} || true

        # Create a chain that only allows whitelisted IPs through.
        ip46tables --new-chain ${chain}

        # Allow trusted interfaces through.
        ${allow-interface config.networking.firewall.trustedInterfaces}

        # Allow local whitelisted IPs through
        ${allow-ip "iptables" IPv4Whitelist}
        ${allow-ip "ip6tables" IPv6Whitelist}

        # Allow Cloudflare's IP ranges through.
        ${allow-ip "iptables" cfipv4}
        ${allow-ip "ip6tables" cfipv6}

        # Everything else is dropped.
        #
        # TODO: I would like to use `nixos-fw-log-refuse` here, but I keep
        #       running into weird issues when reloading the firewall.
        #       Something about the table not being deleted properly.
        ip46tables --append ${chain} -p tcp -m multiport --dports http,https --jump DROP

        # Inject our chain as the first check in INPUT (before nixos-fw).
        # We want to capture any new incomming TCP connections.
        ip46tables --insert INPUT 1 --protocol tcp --destination-port 80 --syn --jump ${chain}
        ip46tables --insert INPUT 1 --protocol tcp --destination-port 443 --syn --jump ${chain}
      '';
      extraStopCommands = ''
        # Clean up added rulesets (${chain}). This mirrors the behavior of the
        # default firewall at the time of writing.
        #
        # See: https://github.com/NixOS/nixpkgs/blob/ac911bf685eecc17c2df5b21bdf32678b9f88c92/nixos/modules/services/networking/firewall-iptables.nix#L218-L219
        ip46tables --delete INPUT --protocol tcp --destination-port 80  --syn --jump ${chain} 2>/dev/null || true
        ip46tables --delete INPUT --protocol tcp --destination-port 443 --syn --jump ${chain} 2>/dev/null || true
      '';
    };


}