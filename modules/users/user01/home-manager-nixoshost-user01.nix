# Home manager configuration for user01 in a nixos host
#https://github.com/GaetanLepage/nix-config/blob/master/modules/home/core/default.nix
{

  flake.modules.nixos.home-manager-nixoshost-user01 =
   { config, inputs, ... }:
   let
      inherit (config.networking) hostName;
      userName = inputs.pconf.global-var.user01;
      userNumber = "user01";
    in
    {
      imports = [ inputs.self.modules.nixos.home-manager ];

      home-manager = {

        users.${userName}.imports = [

          inputs.self.modules.homeManager."home-manager-${userNumber}" # User specific home manager module
          (inputs.self.modules.homeManager."host_${hostName}_${userNumber}" or { }) # Host specific home manager modules for the user

        ];

      };

      #custom.imp.homeManager.directories = [ "/home/${config.home.username}" ];

    };
}
