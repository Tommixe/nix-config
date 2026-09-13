{
  flake.modules.nixos.xbootldr = {
    boot.loader = {
      systemd-boot = {
        xbootldrMountPoint = "/boot";
      };
      efi.efiSysMountPoint = "/efi";
    };
  };

}
