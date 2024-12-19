{
  config,
  pkgs,
  lib,
  ...
}:
let
  allowList = lib.strings.concatMapStringsSep "\n" (x: "allow ${x};");
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
  #https://github.com/heywoodlh/nixos-configs/tree/master/nixos/roles/monitoring

  services.zabbixServer.enable = true;

  services.zabbixWeb = {
    enable = true;
    virtualHost = {
      listen = [
        {
          ip = "*";
          port = 8080;
        }
      ];
    };
  };

  services.nginx.virtualHosts = {
    "zabbix.tzero.it" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://localhost:8080";
      extraConfig = ''
        proxy_set_header  X-Script-Name /;
        proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass_header Authorization;
        ${allowList cfipv4}
        ${allowList cfipv6}
        deny all;
      '';
    };
  };

  # technically not needed on the server, but good for testing.
  services.zabbixAgent = {
    enable = true;
    server = "cloud01";
  };

  # Open necessary ports
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [
    8080
    10051
  ];
}
