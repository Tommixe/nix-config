{
  flake.modules.homeManager.hmuser01 =
    {
      lib,
      inputs,
      config,
      configName,
      ...
    }:
    let
      userName = "tommaso";
      hostConfig = config.nixosHosts.${configName} or { };
      persistenceEnabled = hostConfig.enablePersistence or false;
    in
    {

      imports = [ inputs.impermanence.nixosModules.home-manager.impermanence ];

      home = {
        username = userName;
        stateVersion = lib.mkDefault "23.05";
        sessionPath = [ "$HOME/.local/bin" ];
        homeDirectory = "/home/${userName}";
      };

      # Separate persistence configuration
      home.persistence = lib.mkIf persistenceEnabled {
        "/persist/home/${userName}".allowOther = true;
      };
    };
}
