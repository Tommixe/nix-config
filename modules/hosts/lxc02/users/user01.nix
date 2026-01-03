{ config, ... }:
{
  
  # To build HomeConfiguration flake output so it is possibile to run home manager switch without nixos-rebuild
  homeHosts."user01@lxc02" = {
    unstable = true;
    modules = with config.flake.modules.homeManager; [
      home-user01
      host_lxc02_user01
    ];
  };

# Add user01 to host lxc02
  flake.modules.nixos.host_lxc02 = {
    imports =
      with config.flake.modules.nixos; [
      user01 # Define simple linux user
      home-manager-nixoshost-user01  # Enable home manager for user
      ];
  };

# Add host specific homeManager modules and flatpak packages for user01 on host lxc02
  flake.modules.homeManager.host_lxc02_user01 = {
    imports = with config.flake.modules.homeManager; [
      imp-home #Enable impermanence for user01
      imp-options #Enable impermanence for user01
    ];
    
  };

  

}
