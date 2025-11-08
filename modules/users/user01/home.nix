#https://github.com/GaetanLepage/nix-config/blob/master/modules/home/core/default.nix
topLevel@{
  lib,
  config,
  inputs,
  ...
}:
{

  homeHosts.user01 = {
    unstable = true;
    modules = with config.flake.modules.homeManager; [
      base
      user01
    ];
  };

  flake.modules.nixos.home-manager-user01 =
    { lib, config, ... }:
    let
      inherit (config.networking) hostName;
      userName = "user01";
     # homeVersion =
     #   if lib.versions.majorMinor lib.version == "25.05" then
     #     inputs.home-manager.nixosModules.home-manager
     #   else
     #     inputs.home-manager-unstable.nixosModules.home-manager;
    in
    {
    
      #imports = [
      #  homeVersion
      #];

      # programs = {
      #   home-manager.enable = true;
      #   git.enable = true;
      # };

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "hm-backup";

        users.${userName}.imports = [
          topLevel.config.flake.modules.homeManager.base
          topLevel.config.flake.modules.homeManager.hmuser01
          (topLevel.config.flake.modules.homeManager."host_${hostName}" or { })
          # {
          #   age = {
          #     identityPaths = [ config.age.secrets.agenix-home-secret-key.path ];
          #     rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBE+2at1NN5ahYloIOYXyEhGi6lRN4PoapQz6CNoTo0r";
          #   };
          # }
        ];

        extraSpecialArgs = {
          inputs = inputs;
          configName = "nixos_${hostName}";
          nhSwitchCommand = "nh os switch";
        };
      };

      #custom.imp.homeManager.directories = [ "/home/${config.home.username}" ];

    };
}
