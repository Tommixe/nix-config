{
  flake.modules.homeManager.ente-auth =
{
  pkgs,
  ...
}:
{

  home.packages =  [
    pkgs.ente-auth
  ];
  
};
}