#https://github.com/GaetanLepage/nix-config/blob/master/modules/home/core/default.nix
topLevel@{
  inputs,
  config,
  ...
}:
{

  homeHosts.user01 = {
    unstable = true;
    modules = with config.flake.modules.homeManager; [
      base
      home-user01
      imp-home
      imp-options
    ];
  };

  flake.modules.nixos.home-manager-user01 =
    { lib, config, ... }:
    let
      inherit (config.networking) hostName;
      userName = "user01";

      home-manager-input =
        if lib.versions.majorMinor lib.version == "25.05" then
          inputs.home-manager.nixosModules.default
        else
          inputs.home-manager-unstable.nixosModules.default;

    in
    {

      #imports = [ home-manager-input ];

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "hm-backup";

        users.${userName}.imports = [
          topLevel.config.flake.modules.homeManager.base
          topLevel.config.flake.modules.homeManager.home-user01
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
          configName = "${hostName}";
          nhSwitchCommand = "nh os switch";
        };
      };

      #custom.imp.homeManager.directories = [ "/home/${config.home.username}" ];

    };
}
