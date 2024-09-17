{ config, modulesPath, lib, ... }:
{
  imports = [
    "${modulesPath}/virtualisation/proxmox-lxc.nix"

    #../common/users/user01
    ../common/optional/fail2ban.nix
    #../common/global/acme.nix
    ../common/global/auto-upgrade.nix
    ../common/global/fish.nix
    ../common/global/locale.nix
    ../common/global/nix.nix
    ../common/global/openssh.nix
    #../common/global/optin-persistence.nix
    #./podman.nix
    ../common/global/sops.nix
    #../common/global/ssh-serve-store.nix
    #./steam-hardware.nix
    #./systemd-initrd.nix
    #../common/global/tailscale.nix
    #../common/global/zabbix-agent.nix

  ];

  proxmoxLXC.manageHostName = true;
  networking = {
    hostName = lib.mkForce "lxc01";
    useDHCP = lib.mkForce true;
  };

  users.mutableUsers = false;
  users.users.user01 = {
    name = "tommaso";
    isNormalUser = true;
    uid = 1000;
    #shell = pkgs.fish;
    extraGroups =
      [
        "wheel"
        "video"
        "audio"
        #"tommaso"
      ]

  openssh.authorizedKeys.keys = [ (builtins.readFile ../../home/user01/ssh.pub) ];
  hashedPasswordFile = config.sops.secrets.user01-password.path;
    packages = [ pkgs.home-manager ];
  };

  users.groups.tommaso.gid = 1000;

  sops.secrets.user01-password = {
    sopsFile = ../../secrets.yaml;
    neededForUsers = true;
  };

   system.stateVersion = "24.05";
}
