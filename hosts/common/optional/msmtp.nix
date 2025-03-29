{ config, ... }:
let
  global-var = builtins.extraBuiltins.sopsImportEncrypted ../global-var.nix.sops;
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
        host = global-var.msmtp-host;
        port = 465; #"cat ${config.sops.secrets.msmtp-port.path}";
        user = global-var.msmtp-user;
        passwordeval = "cat ${config.sops.secrets.msmtp-passwordeval.path}";
        from = global-var.msmtp-from;
      };
    };
  };

  sops.secrets = {
    msmtp-passwordeval = {
      sopsFile = ../secrets.yaml;
    };
  };
}
