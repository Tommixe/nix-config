{ config, ... }:
{
  services.jackett = {
    enable = true;   
    openFirewall = true;
  };
  
    environment.persistence = {
    "/persist".directories = [
      "/var/lib/jackett"  
    ];
  };

}
