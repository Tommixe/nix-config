{ config, pkgs, lib,... }:
{
  config.virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      nextcloud-aio-mastercontainer = {
        image = "nextcloud/all-in-one:latest";
        ports = [ 
          "80:80" 
          "8080:8080"
          "8443:8443"
        ];
        autoStart = true;
        #extraOptions = ["--restart=always"];
        volumes = [
          "nextcloud_aio_mastercontainer:/mnt/docker-aio-config"
          "/var/run/docker.sock:/var/run/docker.sock:ro"
        ];
        environment = {
          APACHE_PORT = "11000";
          APACHE_IP_BINDING= "0.0.0.0" ;
          NEXTCLOUD_DATADIR= "/nextcloud" ;
        };
      };
    };
  };

  config.services.duplicacy = {
    enable = true;
    instances.nextcloud = {
      backupDir = "/nextcloud";
      onCalendar = "04:30" ;
      email = config.global-var.user01-email01;
    };
  };

   config.services.duplicacy-prune = {
    enable = true;
    instances.nextcloud = {
      backupDir = "/nextcloud";
      onCalendar = "*-*-01 07:30:00";
      email = config.global-var.user01-email01;
    };
  };

  config.services.rsync-scheduled = {
    enable = true;
    instances.nextcloud = {
      onCalendar = "06:30" ;
      email = config.global-var.user01-email01;
      key = "/persist/etc/ssh/ssh_host_ed25519_key";
      source = "/nextcloud/";
      destination = "root@${config.global-var.ip-mox}:/mnt/hd1/nextcloud";
      options = "-azAX --delete --dry-run";
      rules = '' 
        - appdata_oclztnts2txl/
        - files_external/
        - .ocdata
        - .htaccess
        - owncloud.db
        - nextcloud.log
        - index.html
      '';
    };
  };

 
}