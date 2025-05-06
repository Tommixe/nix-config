{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.services.duplicacy;
in
{
  options = {
    services.duplicacy = {

      enable = mkEnableOption "Duplicacy Backup";

      package = mkOption {
        type = types.package;
        default = pkgs.duplicacy;
        description = "Duplicacy package to use.";
      };

      instances = mkOption {
        description = lib.mdDoc "Set of duplicacy instances. The instance named `duplicacy` is the default one.";
        type =
          with types;
          attrsOf (submodule {
            options = {

              backupDir = mkOption {
                type = types.path;
                description = "Directory to backup";
                default = "~/Documents";
              };

              onCalendar = mkOption {
                type = types.nullOr types.str;
                default = "daily";
                description = lib.mdDoc ''
                  How often this instance is started. See systemd.time(7) for more information about the format.
                  Setting it to null disables the timer, thus this instance can only be started manually.
                '';
              };

              email = mkOption {
                  type = types.str;
                  default = "mail@nomail.com";
                  description = "Mail address where to send backup job notifications";
              };

            };
          });
      };
    };
  };

  config = mkIf cfg.enable {

    systemd.services = mapAttrs' (name: instance: {
      name = "duplicacy-${name}";
      value = {
        description = "Duplicacy Backup Service ${name}";
        wants = [ "network-online.target" ];
        after = [ "network-online.target" ];
        postStop = ''
        echo "Subject:Backup" | cat - ${instance.backupDir}/.duplicacy/logs/duplicacy-backup.log | ${pkgs.msmtp}/bin/msmtp ${instance.email}
        '';
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${cfg.package}/bin/duplicacy -log backup -stats";
          #User = cfg.user;
          #Group = cfg.group;
          WorkingDirectory = instance.backupDir;
          StandardOutput = "file:${instance.backupDir}/.duplicacy/logs/duplicacy-backup.log";
          #Restart = "on-failure";
          # Other service configurations...
        };
      };
    }) cfg.instances;

    systemd.timers = mapAttrs' (name: instance: {
      name = "duplicacy-${name}";
      value = {
        description = "Timer to take duplicacy backup";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = instance.onCalendar;
          AccuracySec = "10min";
          Persistent = true;
        };
      };
    }) (filterAttrs (name: instance: instance.onCalendar != null) cfg.instances);
  };
}
