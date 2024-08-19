{ config, ... }:
{
  #services.kasmweb = {
  #  enable = true;
  #};

  environment.persistence = {
    "/persist".directories = [
      "/srv/kasm"
      "/srv/kasmprofiles"
    ];
  };

  networking.firewall = {
    allowedTCPPorts = [
      3000
      443
    ];
    allowedUDPPorts = [
      3000
      443
    ];
  };
}
