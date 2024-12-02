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
    gnome-tweaks
    gnome-software
    gnomeExtensions.appindicator
    gnomeExtensions.gsconnect
  ];
}
