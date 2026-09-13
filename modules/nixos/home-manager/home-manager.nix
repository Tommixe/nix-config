{
  flake.modules.nixos.home-manager =
  { config, inputs,  ... }:
  let
    inherit (config.networking) hostName;
    in
    {
      home-manager = {
        
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "hm-backup";
      
        extraSpecialArgs = {
          inputs = inputs;
          configName = "${hostName}";
          nhSwitchCommand = "nh os switch";
        };      
      
      
      };
    };

}
