{ 
  flake.modules.nixos.systemd-initrd = {
      boot.initrd.systemd.enable = true; 
  };
}
