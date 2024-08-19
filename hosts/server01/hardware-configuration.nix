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
        "ahci"
        "xhci_pci"
        "virtio_pci"
        "sr_mod"
        "virtio_blk"
      ];
      #kernelModules = [ "kvm-intel" ];
      kernelModules = [ "nfs" ];
    };
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
    };
  };

  disko.devices = import ./diskconfig.nix {
    lib = nixpkgs.lib;
    hostname = config.networking.hostName;
  };

  fileSystems."/srv/ncdata" = {
    device = "cat ${config.sops.secrets.ip-node2.path}" + ":/ottodata/nextcloud";
    fsType = "nfs";
    options = [ "nfsvers=4.2" ];
  };

  fileSystems."/srv/multimedia" = {
    device = "cat ${config.sops.secrets.ip-node2.path}" + ":/ottodata/data";
    fsType = "nfs";
    options = [ "nfsvers=4.2" ];
  };

  sops.secrets = {
    ip-node2 = {
      sopsFile = ../common/secrets.yaml;
    };
  };

  /*
    fileSystems."/boot" = {
      device = "/dev/disk/by-label/ESP";
      fsType = "vfat";
    };

    swapDevices = [{
      device = "/dev/disk/by-label/swap";
      size = 3048;
    }];
  */

  hardware.cpu.intel.updateMicrocode = true;

  virtualisation.hypervGuest.enable = true;
  systemd.services.hv-kvp.unitConfig.ConditionPathExists = [ "/dev/vmbus/hv_kvp" ];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
