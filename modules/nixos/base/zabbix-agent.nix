
{
  flake.modules.nixos.zabbix-agent = 
    { pkgs, lib, ... }:
    {
      #https://github.com/heywoodlh/nixos-configs/tree/master/nixos/roles/monitoring

      services.zabbixAgent = {
        enable = true;
        #package= lib.mkDefault pkgs.zabbix72.agent2;
        server = "cloud01";
      };

      networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 10050 ];
  };
}
