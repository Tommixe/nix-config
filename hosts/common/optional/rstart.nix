{inputs, config, ...}: {

  
  services.rstart-service = {
    enable = true;
    dates = "06:30";
    passwdFilePath = config.sops.secrets.vncpassw.path;
    server =  "cat ${config.sops.secrets.amt-server.path}";
  };

  sops.secrets.vncpassw = {
    sopsFile = ../../../hosts/common/secrets.yaml;
  };

  sops.secrets.amt-server = {
    sopsFile = ../../../hosts/common/secrets.yaml;
  };

}