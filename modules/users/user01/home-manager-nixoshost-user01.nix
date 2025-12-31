# Home manager configuration for user01 in a nixos host
#https://github.com/GaetanLepage/nix-config/blob/master/modules/home/core/default.nix
{
  inputs,
  ...
}:
{

  
  flake.modules.nixos.home-manager-nixoshost-user01 =
    { config, ... }:
    let
      inherit (config.networking) hostName;
      userName = "user01";
    in
    {
      
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "hm-backup";

        users.${userName}.imports = [
          #topLevel.config.flake.modules.homeManager.base
          inputs.self.modules.homeManager."home-manager-${userName}" # User specific home manager module
          (inputs.self.modules.homeManager."host_${hostName}_${userName}" or { }) # Host specific home manager modules for the user
          # {
          #   age = {
          #     identityPaths = [ config.age.secrets.agenix-home-secret-key.path ];
          #     rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBE+2at1NN5ahYloIOYXyEhGi6lRN4PoapQz6CNoTo0r";
          #   };
          # }
        ];

        extraSpecialArgs = {
          inputs = inputs;
          configName = "${hostName}";
          nhSwitchCommand = "nh os switch";
        };
      };

      #custom.imp.homeManager.directories = [ "/home/${config.home.username}" ];

    };
}
