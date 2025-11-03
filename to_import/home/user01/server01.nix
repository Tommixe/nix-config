{ inputs, outputs, ... }:
{
  imports = [ ./global ];

  colorscheme = inputs.nix-colors.colorschemes.atelier-sulphurpool;
}
