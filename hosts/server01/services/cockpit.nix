{ config, ... }:
{
  services.cockpit = {
    enable = true;
    openFirewall = true;
  };
}
