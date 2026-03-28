{

  flake.modules.nixos.host_ws02 =

    {
      inputs,
      lib,
      ...
    }:
    {

      imports = [
        (inputs.modulesPath + "/installer/scan/not-detected.nix")
        inputs.disko.nixosModules.disko
        inputs.nixpkgs
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
            consoleMode = "max";
          };
          efi.canTouchEfiVariables = true;
        };
      };

      disko.devices = import ./diskconfig.nix {
        lib =  inputs.nixpkgs.lib;
        hostname = "ws02";
      };

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      #hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    };
}
