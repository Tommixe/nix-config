{ lib, config, ... }:
{
  # Enable acme for usage with nginx vhosts
  security.acme = {
    defaults.email = "cat ${config.sops.secrets.user01-email01.path}";
    acceptTerms = true;
  };

  sops.secrets.user01-email01 = {
    sopsFile = ../secrets.yaml;
  };

  environment.persistence = {
    "/persist" = {
      directories = [ "/var/lib/acme" ];
    };
  };
}
