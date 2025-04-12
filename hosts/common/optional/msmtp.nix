{ config, inputs, ... }:
let
  sconf = inputs.pconf ;
in
{

  programs.msmtp = {
    enable = true;
    accounts = {
      default = {
        auth = true;
        tls = true;
        tls_starttls = false;
        tls_trust_file = "/etc/ssl/certs/ca-certificates.crt";
        host = sconf.msmtp-host; #"cat ${config.sops.secrets.msmtp-host.path}";
        port = 465; #"cat ${config.sops.secrets.msmtp-port.path}";
        user = sconf.msmtp-user; #"cat ${config.sops.secrets.msmtp-user.path}";
        passwordeval = "cat ${config.sops.secrets.msmtp-passwordeval.path}";
        from = sconf.msmtp-from; #"cat ${config.sops.secrets.msmtp-from.path}";
      };
    };
  };

  sops.secrets = {
      msmtp-passwordeval = {
      sopsFile = ../secrets.yaml;
    };    
  };
}
