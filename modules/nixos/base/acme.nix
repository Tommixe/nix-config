{
  flake.modules.nixos.base = 
    { config, ... }:
    {

    # Enable acme for usage with nginx vhosts
    security.acme = {
      defaults.email = config.global-var.user01-email01;
      acceptTerms = true;
    };

    custom.imp.root.directories = ["/var/lib/acme"] ;
  
  };

}
