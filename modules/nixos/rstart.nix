{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.services.rstart-service;
  #cfgrstart = config.programs.rstart;
  #package = pkgs.rstart;
in
{
  options = {

    services.rstart-service = {

      enable = mkEnableOption "rstart";

      package = mkOption {
        type = types.package;
        default = pkgs.rstart;
        description = "rstart pkg";
      };

      dates = lib.mkOption {
        type = lib.types.str;
        default = "04:40";
        example = "daily";
      };

      passwdFilePath = lib.mkOption {
        default = "/run/secrets/vncpassw";
        type = with lib.types; nullOr string;
        description = ''
          Default vnc password file path.
        '';
        };

      serverFilePath = lib.mkOption {
        default = "/run/secrets/serverip";
        type = with lib.types; nullOr string;
        description = ''
          File path of the file conatining server ip which send F2 key.
        '';
        };
    
    };
   

  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.xvfb-run pkgs.tigervnc pkgs.xvkbd];

    systemd.services.rstart-service = {
      description = "rstart service send F2 key to remote server";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "bash ${cfg.package}/bin/rstart ${cfg.passwdFilePath} ${cfg.serverFilePath}";
        };
    };

    systemd.timers.rstart-service =  {
      description = "Timer to run rstart program";
      wantedBy = [ "timers.target" ];
      timerConfig = {
          OnCalendar = cfg.dates;
          AccuracySec = "10min";
          Persistent = true;
        };
    };
    

  };
}
