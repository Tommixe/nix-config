{
  config,
  lib,
  pkgs,
  modulesPath,
  nixpkgs,
  disko,
  inputs,
  ...
}:
{
  imports = [ inputs.disko.nixosModules.disko ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" ];
    };
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
    };
  };

  #hardware.raspberry-pi."3".i2c1.enable = true;

  disko.devices = import ./diskconfig.nix {
    lib = nixpkgs.lib;
    hostname = config.networking.hostName;
  };

  nixpkgs.hostPlatform.system = "aarch64-linux";

  powerManagement.cpuFreqGovernor = "ondemand";
}
