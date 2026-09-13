{

  flake.modules.nixos.incus =
    {

        virtualisation.incus.enable = true;
        virtualisation.incus.ui.enable = true;

    };
}
