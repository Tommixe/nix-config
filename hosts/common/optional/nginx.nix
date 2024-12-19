{ lib, config, pkgs, ... }:
let
  inherit (config.networking) hostName;
  realIpsFromList = lib.strings.concatMapStringsSep "\n" (x: "set_real_ip_from  ${x};");
  allowList = lib.strings.concatMapStringsSep "\n" (x: "allow  ${x};");
  fileToList = x: lib.strings.splitString "\n" (builtins.readFile x);
  cfipv4 = fileToList (pkgs.fetchurl {
            url = "https://www.cloudftlare.com/ips-v4";
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
          ${allowList cfipv4}
          ${allowList cfipv6}
          real_ip_header CF-Connecting-IP;
          deny all;
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
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
