{
  flake.modules.nixos.host_rpi01 =
    { inputs, ... }:
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

      disko.devices = import ./_diskconfig.nix {
        lib = inputs.nixpkgs.lib;
        hostname = "rpi01";
      };

      nixpkgs.hostPlatform.system = "aarch64-linux";

      powerManagement.cpuFreqGovernor = "ondemand";
    };
}
