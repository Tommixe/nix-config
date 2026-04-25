{
  flake.modules.nixos.host_server02 =
    { inputs, lib, ... }:
    {
      imports = [
        (inputs.nixpkgs + "/nixos/modules/profiles/qemu-guest.nix")
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

      hardware.cpu.intel.updateMicrocode = true;
      virtualisation.hypervGuest.enable = true;
      systemd.services.hv-kvp.unitConfig.ConditionPathExists = [ "/dev/vmbus/hv_kvp" ];

      disko.devices = import ./_diskconfig.nix {
        lib = inputs.nixpkgs.lib;
        hostname = "server02";
      };

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    };
}
