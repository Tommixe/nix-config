{
  config,
  pkgs,
  lib,
  ...
}:
{
  #https://github.com/heywoodlh/nixos-configs/tree/master/nixos/roles/monitoring

  #services.zabbixServer.enable = true;

  services.zabbixServer = {
      enable = true;
      package = pkgs.zabbix72.server;
      database.type = "pgsql";
      extraPackages = with pkgs; [
        nettools
        nmap
        traceroute
      ];
    };

  services.zabbixWeb = {
    enable = true;
    package = pkgs.zabbix72.web;
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
      '';
    };
  };

  # technically not needed on the server, but good for testing.
  services.zabbixAgent = {
    enable = true;
    package = lib.mkForce pkgs.zabbix72.agent2;
    server = "cloud01";
  };

  # Open necessary ports
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [
    8080
    10051
  ];
}
