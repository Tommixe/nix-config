{
  boot.loader = {
    systemd-boot = {
      enable = true;
      consoleMode = "auto";
    };
    efi.canTouchEfiVariables = true;
  };
}
