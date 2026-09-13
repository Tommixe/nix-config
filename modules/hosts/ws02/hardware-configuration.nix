{

  flake.modules.nixos.host_ws02 =

    {
      modulesPath,
      inputs,
      lib,
      ...
    }:
    {

      imports = [
        "${modulesPath}/installer/scan/not-detected.nix"
        inputs.disko.nixosModules.disko
      ];

      boot = {
        initrd = {
          availableKernelModules = [
            "xhci_pci"
            "ahci"
            "nvme"
            "usbhid"
            "usb_storage"
            "sd_mod"
          ];
          kernelModules = [ "dm-snapshot" ];
        };
        kernelModules = [ "kvm-intel" ];
        loader = {
          systemd-boot = {
            enable = true;
            consoleMode = "auto";
          };
          efi.canTouchEfiVariables = true;
        };
      };

      disko.devices = import ./_diskconfig.nix {
        lib =  inputs.nixpkgs.lib;
        hostname = "ws02";
      };

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      #hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    };
}
