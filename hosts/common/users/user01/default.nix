{ pkgs, config, ... }:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{

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
        "tommaso"
      ]
      ++ ifTheyExist [
        "minecraft"
        "network"
        "wireshark"
        "i2c"
        "mysql"
        "docker"
        "podman"
        "git"
        "libvirtd"
        "deluge"
      ];

    openssh.authorizedKeys.keys = [ (builtins.readFile ../../../../home/user01/ssh.pub) ];
    hashedPasswordFile = config.sops.secrets.user01-password.path;
    packages = [ pkgs.home-manager ];
  };

  users.groups.tommaso.gid = 1000;

  sops.secrets.user01-password = {
    sopsFile = ../../secrets.yaml;
    neededForUsers = true;
  };

  home-manager.users.user01 = import ../../../../home/user01/${config.networking.hostName}.nix;

  environment.persistence = {
    "/persist".directories = [ "/home/tommaso" ];
    #allowOther = true;
  };

  #services.geoclue2.enable = true;
  #security.pam.services = { swaylock = { }; };
}
