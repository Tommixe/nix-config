{

  flake.modules.nixos.user02 =
    { inputs, config, ... }:
    let
      username =  inputs.pconf.global-var.user02;
    in
    {

      users.mutableUsers = false;
      users.users."${username}"= {
        name = "${username}";
        isNormalUser = true;
        extraGroups = [
          "video"
          "audio"
        ];
           
        hashedPasswordFile = config.sops.secrets.user02-password.path;
                
      };

     
      sops.secrets.user02-password = {
        sopsFile = ../../secrets/secrets.yaml;
        neededForUsers = true;
      };


      

      # Enable persistence for user02 home directory eventually shoudl be done in home-manager module only
      # and I should remove this, but means I need to manage the persistence of every
      # folder in home manually
      custom.imp.root.directories = [ "/home/${username}" ];
     
     
    };

}
