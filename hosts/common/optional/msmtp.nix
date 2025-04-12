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
        host = "cat ${config.sops.secrets.msmtp-host.path}";
        port = 465; #"cat ${config.sops.secrets.msmtp-port.path}";
        user = "cat ${config.sops.secrets.msmtp-user.path}";
        passwordeval = "cat ${config.sops.secrets.msmtp-passwordeval.path}";
        from = "cat ${config.sops.secrets.msmtp-from.path}";
      };
    };
  };

  sops.secrets = {
    msmtp-host = {
      sopsFile = ../secrets.yaml;
    };
    #msmtp-port = {
    #  sopsFile = ../secrets.yaml;
    #};
    msmtp-user = {
      sopsFile = ../secrets.yaml;
    };
    msmtp-passwordeval = {
      sopsFile = ../secrets.yaml;
    };
    msmtp-from = {
      sopsFile = ../secrets.yaml;
    };
  };
}
