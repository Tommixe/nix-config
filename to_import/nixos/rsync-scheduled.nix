
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.services.rsync-scheduled;
in
{
  options = {
    services.rsync-scheduled = {

      enable = mkEnableOption "rsync-scheduled Backup";

      package = mkOption {
        type = types.package;
        default = pkgs.rsync;
        description = "rsync-scheduled package to use.";
      };

      instances = mkOption {
        description = lib.mdDoc "Set of rsync-scheduled instances. The instance named `rsync-scheduled` is the default one.";
        type =
          with types;
          attrsOf (submodule {
            options = {

              logDir = mkOption {
                type = types.path;
                description = "Directory where store logs";
                default = "/var/log/rsync-scheduled";
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

              key = mkOption {
                  type = str;
                  description = "SSH keypair to use";
                  default = cfg.key;
                  example = "/root/id_backup";
              };

              source = mkOption {
                  type = str;
                  description = "rsync source, remember trailing /";
                  example = "/nextcloud/";
              };
          
              destination = mkOption {
                  type = str;
                  description = "rsync destination";
                  example = "root@10.10.10.8:/mnt/hdd/data";
              };

              options = mkOption {
                  type = str;
                  description = "rsync options";
                  example = "--ignore-errors -q -azHAXL --delete --delete-excluded";
              };

              rules = mkOption {
                  type = str;
                  description =
                    "rsync filter rules, see <literal>man rsync</literal>";
                  default = "";
                  example = ''
                    + /srv
                    - *
                  '';
              };
            };
          });
      };
    };
  };

  config = mkIf cfg.enable {

    systemd.services = mapAttrs' (name: instance: {
      name = "rsync-scheduled-${name}";
      value = {
        description = "rsync-scheduled Backup Service ${name}";
        wants = [ "network-online.target" ];
        after = [ "network-online.target" ];
        postStop = ''
        echo "Subject: Rsync ${name}" && cat - ${instance.logDir}/rsynclogs.log | ${pkgs.msmtp}/bin/msmtp ${instance.email}
        '';
        serviceConfig = {
          Type = "oneshot";
          #ExecStart = "${cfg.package}/bin/rsync -v -e 'ssh -i ${instance.key}' ${instance.options} ${instance.source} ${instance.destination} ";
          #WorkingDirectory = instance.backupDir;
          ExecStart = "${
              pkgs.writeShellApplication {
                name = "rsync-scheduled-${name}.sh";
                runtimeInputs = [ pkgs.rsync pkgs.openssh ];
                text = ''
                    ${cfg.package}/bin/rsync -v -e 'ssh -i ${instance.key}' ${instance.options}  ${
                      if instance.rules == "" then
                        ""
                      else
                        "-f 'merge ${pkgs.writeText "${name}.rsync.rules" "${instance.rules}"}' "
                    } ${instance.source} ${instance.destination}; 
                '';
              }
            }/bin/rsync-scheduled-${name}.sh";
          StandardOutput = "file:${instance.logDir}/rsynclogs.log";
          #Restart = "on-failure";
          # Other service configurations...
        };
      };
    }) cfg.instances;

    systemd.timers = mapAttrs' (name: instance: {
      name = "rsync-scheduled-${name}";
      value = {
        description = "Timer to take rsync-scheduled backup";
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