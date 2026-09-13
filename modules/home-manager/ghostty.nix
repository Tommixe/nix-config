{
  flake.modules.homeManager.ghostty =
{
  pkgs,
  ...
}:
{

  home.packages =  [
    pkgs.ghostty
  ];
  
};
}