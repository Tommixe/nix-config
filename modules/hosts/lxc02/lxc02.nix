# Source: https://discourse.nixos.org/t/cannot-set-file-attributes-for-var-empty/35129/14 
# IMPORTANT on proxmox host run for every lxc:
# root@pve-1:~# pct mount 102
# mounted CT 102 in '/var/lib/lxc/102/rootfs'
# root@pve-1:~# chattr +i /var/lib/lxc/102/rootfs/var/empty
# root@pve-1:~# pct unmount 102



#https://github.com/GaetanLepage/nix-config/blob/master/modules/hosts/framework/default.nix
{
  config,
  lib,
  ...
}:
{
  nixosHosts.lxc02 = {
    unstable = false;
    modules = [
    ];
  };

  flake.modules.nixos.host_lxc02 = 
    {modulesPath, ...}:
    {
    imports = ["${modulesPath}/virtualisation/proxmox-lxc.nix"] 
    ++ (
      # Import the nixos modules for the host `lxc02`.
      with config.flake.modules.nixos; [
        # Modules
        acme
        fail2ban
        docker
        portainer
        tailscale-server-local
        msmtp
        nextcloud-aio
        ssh-serve-store
        sops
        imp # optional to enable persistence i.e. create /persist directories to be preserved by impermanence, can be used without ephemeral-btrfs-lvm
        imp-options # This module must be always turn on even if imp is off automatically add persist directories for some services
        pii
        auto-upgrade
      ]);


    networking = {
      hostName = "lxc02";
      useDHCP = lib.mkDefault true;
    };

    nixpkgs.config.allowUnfree = true;


    networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

    users.groups = {
      www-data = {
        gid = 33;
      };
    };

    users.users.www-data = {
      uid = 33;
      group = "www-data";
    };

    proxmoxLXC.manageHostName = true;
    

    system.stateVersion = "24.05";

  };
}
