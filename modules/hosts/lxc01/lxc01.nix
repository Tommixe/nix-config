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
  nixosHosts.lxc01 = {
    unstable = false;
    modules = [
    ];
  };

  flake.modules.nixos.host_lxc01 =
    {modulesPath, ...}:
    {
    imports = ["${modulesPath}/virtualisation/proxmox-lxc.nix"]
    ++ (
      # Import the nixos modules for the host `lxc01`.
      with config.flake.modules.nixos; [
        # Modules
        fail2ban
        tailscale-server-local
        rstart
        jellyfin
        lidarr
        jackett
        #prowlarr
        radarr
        sonarr
        transmission
        sops
        imp # optional to enable persistence i.e. create /persist directories to be preserved by impermanence, can be used without ephemeral-btrfs-lvm
        imp-options # This module must be always turn on even if imp is off automatically add persist directories for some services
        pii
        auto-upgrade
      ]);


    networking = {
      hostName = "lxc01";
      useDHCP = lib.mkDefault true;
    };


    nixpkgs.config.allowUnfree = true;

    nixpkgs.config = {
       # FIXME
      #https://discourse.nixos.org/t/solved-sonarr-is-broken-in-24-11-unstable-aka-how-the-hell-do-i-use-nixpkgs-config-permittedinsecurepackages/56828/6
      permittedInsecurePackages = [
            "openssl-1.1.1u"
            "dotnet-runtime-wrapped-6.0.36"
            "aspnetcore-runtime-6.0.36"
            "aspnetcore-runtime-wrapped-6.0.36"
            "dotnet-sdk-6.0.428"
            "dotnet-sdk-wrapped-6.0.428"
            "dotnet-runtime-6.0.36"
      ];
    };

    users.groups =  {
      www-data = {
        gid = 33;
        members = [ "radarr" "sonarr" "jellyfin" "transmission" "lidarr" "prowlarr" ];
      };
    };

    proxmoxLXC.manageHostName = true;


    system.stateVersion = "24.05";

  };
}