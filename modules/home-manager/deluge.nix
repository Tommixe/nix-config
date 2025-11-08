{
  flake.modules.homeManager.deluge =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ deluge ];
    };
}
