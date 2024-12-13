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
    gnomeExtensions.dash-to-dock
    gnomeExtensions.blur-my-shell
    gnomeExtensions.clipboard-indicator
  ];
}
