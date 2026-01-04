# Home manager configuration for user02 in a nixos host
#https://github.com/GaetanLepage/nix-config/blob/master/modules/home/core/default.nix
{
  inputs,
  ...
}:
{

  
  flake.modules.nixos.home-manager-nixoshost-user02 =
    { config,  ... }:
    let
      inherit (config.networking) hostName;
      userName = "user02";
    in
    {
      
            imports = [ inputs.self.modules.nixos.home-manager ];


      home-manager = {
        

        users.${userName}.imports = [
           inputs.self.modules.homeManager."home-manager-${userName}" # User specific home manager module
          (inputs.self.modules.homeManager."host_${hostName}_${userName}" or { }) # Host specific home manager modules for the user
        ];

        
      };

      #custom.imp.homeManager.directories = [ "/home/${config.home.username}" ];

    };
}
