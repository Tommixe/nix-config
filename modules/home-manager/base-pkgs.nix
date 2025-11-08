{
  flake.modules.homeManager.base =
{
   pkgs,
  ...
}:
{
  
   home.packages = with pkgs; [
    #xdg-utils-spawn-terminal
    #bitwarden
    bitwarden-cli
    vscode
    #obsidian
    brave
    nextcloud-client
    calibre
  ];

};
}