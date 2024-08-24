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
    device = "mox.tzero.lan:/ottodata/nextcloud";
    fsType = "nfs";
    options = [ "nfsvers=4.2" ];
  };

  fileSystems."/srv/multimedia" = {
    device = "mox.tzero.lan:/ottodata/data";
    fsType = "nfs";
    options = [ "nfsvers=4.2" ];
  };


  hardware.cpu.intel.updateMicrocode = true;

  virtualisation.hypervGuest.enable = true;
  systemd.services.hv-kvp.unitConfig.ConditionPathExists = [ "/dev/vmbus/hv_kvp" ];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
