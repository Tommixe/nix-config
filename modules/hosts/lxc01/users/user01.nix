{ config, ... }:
{

  # To build HomeConfiguration flake output so it is possibile to run home manager switch without nixos-rebuild
  homeHosts."user01@lxc01" = {
    unstable = true;
    modules = with config.flake.modules.homeManager; [
      home-manager-user01
      host_lxc01_user01
    ];
  };

  # Add user01 to host lxc01
  flake.modules.nixos.host_lxc01 = {
    imports = with config.flake.modules.nixos; [
      user01 # Define simple linux user
      home-manager-nixoshost-user01 # Enable home manager for user
    ];
  };

  # Add host specific homeManager modules and flatpak packages for user01 on host lxc01
  flake.modules.homeManager.host_lxc01_user01 = {
    imports = with config.flake.modules.homeManager; [
      imp-options # Enable impermanence options for user01
    ];

  };

}