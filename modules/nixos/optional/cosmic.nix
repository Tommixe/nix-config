{

  flake.modules.nixos.cosmic = {
    # Enable the COSMIC login manager
    #services.displayManager.cosmic-greeter.enable = true;

    # Enable the COSMIC desktop environment
    services.desktopManager.cosmic.enable = true;

    #allow rdp
    networking.firewall.allowedTCPPorts = [ 3389 ];
    networking.firewall.allowedUDPPorts = [ 3389 ];
  };

}
