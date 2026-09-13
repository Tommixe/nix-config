{

  flake.modules.nixos.virt-manager =
    {

      virtualisation.libvirtd.enable = true;
      programs.virt-manager.enable = true;

    };
}
