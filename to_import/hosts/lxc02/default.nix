{ config, modulesPath, lib, ... }:
{
  imports = [
    "${modulesPath}/virtualisation/proxmox-lxc.nix"

    ../common/global/default-lxc.nix
    ../common/users/user01
    ../common/optional/fail2ban.nix
    ../common/optional/docker.nix
    ../common/optional/portainer.nix
    ../common/optional/tailscale-server-local.nix
    ../common/optional/msmtp.nix
    ./services

  ];
 
  users.groups =  {
    www-data = {
      gid = 33;
    };
  };

  users.users.www-data = {
    uid = 33;
    group = "www-data";
  };
  
  proxmoxLXC.manageHostName = true;
  networking = {
    hostName = lib.mkForce "lxc02";
    useDHCP = lib.mkForce true;
  };
 
   system.stateVersion = "24.05";
}
