{ config, ... }:
{
  
  programs.msmtp = {
    enable = true;
    accounts = {
      default = {
        auth = true;
        tls = true;
        tls_starttls = false;
        tls_trust_file = "/etc/ssl/certs/ca-certificates.crt";
        host = config.global-var.msmtp-host;
        port = 465; #"cat ${config.sops.secrets.msmtp-port.path}";
        user = config.global-var.msmtp-user;
        passwordeval = "cat ${config.sops.secrets.msmtp-passwordeval.path}";
        from = config.global-var.msmtp-from ;
      };
    };
  };

  sops.secrets = {
    msmtp-passwordeval = {
      sopsFile = ../secrets.yaml;
    };
  };

}
