{

  flake.modules.nixos.fail2ban =

    { config, ... }:
    {

      services.rstart-service = {
        enable = true;
        dates = "06:03";
        passwdFilePath = config.sops.secrets.vncpassw.path;
        serverFilePath = config.sops.secrets.amt-server.path;
      };

      sops.secrets.vncpassw = {
        sopsFile = ../../secrets/secrets.yaml;
      };

      sops.secrets.amt-server = {
        sopsFile = ../../secrets/secrets.yaml;
      };

    };
}
