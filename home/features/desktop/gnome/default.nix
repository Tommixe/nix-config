{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [ ../common ];

  home.packages = with pkgs; [
    gnomeExtensions.tailscale-qs
    gnomeExtensions.tailscale-status
    gnome.gnome-tweaks
    gnome.gnome-software
  ];
}
