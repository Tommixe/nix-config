{
  flake.modules.nixos.flatpak = {


    services.flatpak = {
      enable = true;
    };


    custom.imp.root.directories = [ "/var/lib/flatpak" ];
 
  };
}
