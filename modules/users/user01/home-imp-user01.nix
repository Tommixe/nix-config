{
  flake.modules.homeManager.home-imp-user01 =
    {
      lib,
      inputs,
      #config,
      #configName,
      #pe,
      ...
    }:
    let
      userName = "tommaso";
      #hostConfig = config.nixosHosts.${configName} or { };
      persistenceEnabled = false;  #pe || false   ;#hostConfig.enablePersistence or false;
    in
    {

      imports = [ inputs.impermanence.nixosModules.home-manager.impermanence ];

      #Separate persistence configuration
      home.persistence = lib.mkIf persistenceEnabled {
        "/persist/home/${userName}".allowOther = true;
      };

      #home.persistence = lib.mkIf config.enviroment.persistence {
      #  "/persist/home/${userName}".allowOther = true;
      #};



    };
}
