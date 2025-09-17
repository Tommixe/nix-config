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
      members = [ "radarr" "sonarr" "jellyfin" "transmission" "lidarr" "prowlarr" ];
    };
  };
  
  proxmoxLXC.manageHostName = true;
  networking = {
    hostName = lib.mkForce "lxc01";
    useDHCP = lib.mkForce true;
  };

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
  
 
   system.stateVersion = "24.05";
}
