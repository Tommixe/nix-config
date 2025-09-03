{ modulesPath, lib, config, inputs, ... }:
{
  imports = [
    ../common/optional/ephemeral-btrfs-lvm.nix
    # ../common/optional/encrypted-root.nix
    inputs.nixos-facter-modules.nixosModules.facter
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  facter.reportPath = ./facter.json;


 fileSystems."/efi" =
    { device = "/dev/disk/by-uuid/86BF-F822";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
 
/*
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/180c3171-3cb6-4ef4-9d75-ffc54b295483";
      fsType = "btrfs";
      options = [ "subvol=root" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/180c3171-3cb6-4ef4-9d75-ffc54b295483";
      fsType = "btrfs";
      options = [ "subvol=nix" ];
    };

  fileSystems."/persist" =
    { device = "/dev/disk/by-uuid/180c3171-3cb6-4ef4-9d75-ffc54b295483";
      fsType = "btrfs";
      options = [ "subvol=persist" ];
    };
*/

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/3F20-F584";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/ef964a3f-c170-46a9-948c-ba0b987010ce"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp193s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkForce "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

}
