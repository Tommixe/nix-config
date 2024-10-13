{ config, modulesPath, lib, ... }:
{
  imports = [
    "${modulesPath}/virtualisation/proxmox-lxc.nix"

    ../common/global/default-lxc.nix
    ../common/users/user01
    ../common/optional/fail2ban.nix
    ../common/optional/docker.nix
    ../common/optional/portainer.nix

    ./services

  ];
 
  users.groups =  {
    www-data = {
      gid = 33;
    };
  };

  users.users.multimedia = {
    uid = 33;
    extraGroups =
      [
        "www-data"
      ]
  };
  
  proxmoxLXC.manageHostName = true;
  networking = {
    hostName = lib.mkForce "lxc02";
    useDHCP = lib.mkForce true;
  };
 
   system.stateVersion = "24.05";
}
