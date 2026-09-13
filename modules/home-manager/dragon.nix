{
  flake.modules.homeManager.dragon =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ xdragon ];
    };
}
