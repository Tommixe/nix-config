{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [ ./packages.nix ];

  users.mutableUsers = false;
  users.users.user02 = {
    name = "federico";
    isNormalUser = true;
    extraGroups = [
      "video"
      "audio"
    ];
    hashedPasswordFile = config.sops.secrets.user02-password.path;
  };

  sops.secrets.user02-password = {
    sopsFile = ../../secrets.yaml;
    neededForUsers = true;
  };

   home-manager.users.user02 = import ../../../../home/user02/${config.networking.hostName}.nix;

  # Persist entire home
  environment.persistence = {
    "/persist".directories = [ "/home/federico" ];
  };
}
