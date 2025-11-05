topLevel@{ inputs, ... }:
{
  flake.modules.nixos.home-manager =
    { config, ... }:
    {

      imports = [
        inputs.home-manager.nixosModules.home-manager
      ];

      #systemd.user.startServices = "sd-switch";

      home-manager = {

        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "hm-backup";
        #home.stateVersion = "23.05";

        #programs = {
        #  home-manager.enable = true;
        #  git.enable = true;
        #};
      };

    };
}
