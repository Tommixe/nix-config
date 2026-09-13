{
  flake.modules.homeManager.onedriver =
{
  pkgs,
  ...
}:
{

  home.packages =  [
    pkgs.onedriver
  ];
  
};
}