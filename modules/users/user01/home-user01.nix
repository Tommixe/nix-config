{
  flake.modules.homeManager.home-user01 =
    {
      lib,
      #inputs,
      #config,
      #configName,
      #pe,
      ...
    }:
    let
      userName = "tommaso";
      #hostConfig = config.nixosHosts.${configName} or { };
      #persistenceEnabled = pe || false   ;#hostConfig.enablePersistence or false;
    in
    {

      #imports = [ inputs.impermanence.nixosModules.home-manager.impermanence ];

      home = {
        username = userName;
        stateVersion = lib.mkDefault "23.05";
        sessionPath = [ "$HOME/.local/bin" ];
        homeDirectory = "/home/${userName}";
      };

      # Separate persistence configuration
      #home.persistence = lib.mkIf persistenceEnabled {
      #  "/persist/home/${userName}".allowOther = true;
      #};

      #home.persistence = lib.mkIf config.enviroment.persistence {
      #  "/persist/home/${userName}".allowOther = true;
      #};



    };
}
