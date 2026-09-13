{
  flake.modules.homeManager.ranger =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ ranger ];
    };
}
