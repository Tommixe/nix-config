{

  flake.modules.nixos.host_cloud01 =

    {
      inputs,
      ...
    }:

    {

      imports = [
        (inputs.nixpkgs + "/nixos/modules/profiles/qemu-guest.nix")
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

      disko.devices = import ./_diskconfig.nix {
        lib = inputs.nixpkgs.lib;
        hostname = "cloud01";
      };

      nixpkgs.hostPlatform.system = "aarch64-linux";

    };

}