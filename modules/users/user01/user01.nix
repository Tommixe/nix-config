{

  flake.modules.nixos.user01 =
    { pkgs, config, inputs, ... }:
    let
      ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
      username =  inputs.pconf.global-var.user01;
    in
    {

      users.mutableUsers = false;
      users.users."${username}"= {
        name = "${username}";
        isNormalUser = true;
        uid = 1000;
        shell = pkgs.fish;
        extraGroups = [
          "wheel"
          "video"
          "audio"
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
        
        packages = [ 
          pkgs.git 
          pkgs.nix
          pkgs.home-manager
          ];
      
      };

      users.groups.${username}.gid = 1000;

      sops.secrets.user01-password = {
        sopsFile = ../../secrets/secrets.yaml;
        neededForUsers = true;
      };

      

      # Enable persistence for user01 home directory eventually shoudl be done in home-manager module only
      # and I should remove this, but means I need to manage the persistence of every
      # folder in home manually
      custom.imp.root.directories = [ "/home/${username}" ];
      

      #services.geoclue2.enable = true;
      #security.pam.services = { swaylock = { }; };
    };

}
