{

  flake.modules.nixos.user01 =
    { pkgs, config, lib, ... }:
    let
      ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
      username = "tommaso";
    in
    {

      users.mutableUsers = false;
      users.users.user01 = {
        name = "${username}";
        isNormalUser = true;
        uid = 1000;
        shell = pkgs.fish;
        extraGroups = [
          "wheel"
          "video"
          "audio"
          #"tommaso"
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

        openssh.authorizedKeys.keys = [ (builtins.readFile ./ssh.pub) ];
        hashedPasswordFile = config.sops.secrets.user01-password.path;
        packages = [ pkgs.home-manager ];
      };

      users.groups.tommaso.gid = 1000;

      sops.secrets.user01-password = {
        sopsFile = ../../secrets/secrets.yaml;
        neededForUsers = true;
      };

      /*
      home-manager.users.user01 = {
        username = "${username}";
        homeDirectory = lib.mkDefault "/home/${username}";
        stateVersion = lib.mkDefault "23.05";
        sessionPath = [ "$HOME/.local/bin" ];
        persistence."/persist/home/${username}".allowOther = true;
      };
       
               
      
      environment.persistence = {
        "/persist".directories = [ "/home/tommaso" ];
        #allowOther = true;
      };
      */

      #services.geoclue2.enable = true;
      #security.pam.services = { swaylock = { }; };
    };

}
