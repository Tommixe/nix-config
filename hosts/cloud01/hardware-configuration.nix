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
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    inputs.disko.nixosModules.disko
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "virtio_pci"
        "usbhid"
      ];
    };
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
    };
    # Enable nested virtualization
    extraModprobeConfig = "options kvm nested=1";
  };

  disko.devices = import ./diskconfig.nix {
    lib = nixpkgs.lib;
    hostname = config.networking.hostName;
  };

  nixpkgs.hostPlatform.system = "aarch64-linux";
}
