{ config, modulesPath, lib, ... }:
{
  imports = [
    "${modulesPath}/virtualisation/proxmox-lxc.nix"

    ../common/global/default-lxc.nix
    ../common/users/user01
    ../common/optional/fail2ban.nix
    ../common/optional/tailscale-server-local.nix
    ../common/optional/rstart.nix
    ./services

  ];
 
  users.groups =  {
    www-data = {
      gid = 33;
      members = [ "radarr" "sonarr" "jellyfin" "transmission" ];
    };
  };
  
  proxmoxLXC.manageHostName = true;
  networking = {
    hostName = lib.mkForce "lxc01";
    useDHCP = lib.mkForce true;
  };
 
   system.stateVersion = "24.05";
}
