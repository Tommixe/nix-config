{

  flake.modules.nixos.host_hpx360 =
    {lib, ... }:
    {
      hardware.enableRedistributableFirmware = lib.mkDefault true;

      boot = {
        initrd = {
          availableKernelModules = [
            "xhci_pci"
            "ehci_pci"
            "ahci"
            "usb_storage"
            "sd_mod"
            "sdhci_acpi"
            "rtsx_pci_sdmmc"
          ];
          kernelModules = [ "dm-snapshot" ];
        };
        kernelModules = [ "kvm-intel" ];
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/42DC-2011";
        fsType = "vfat";
      };

      swapDevices = [ { device = "/dev/disk/by-uuid/0e40a97a-9deb-4e66-97b8-d397a5cd0544"; } ];

      nixpkgs.hostPlatform.system = "x86_64-linux";
      hardware.cpu.intel.updateMicrocode = true; # lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
