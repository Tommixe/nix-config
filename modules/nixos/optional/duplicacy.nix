{

  flake.modules.nixos.duplicacy =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.duplicacy ];
    };
}
