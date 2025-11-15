{ lib, config, ... }:
{
  options.nixpkgs.allowedUnfreePackages = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
  };

  config.flake = {
    modules =
      let
        predicate = pkg: builtins.elem (lib.getName pkg) config.nixpkgs.allowedUnfreePackages;
      in
      {
        nixos.base.nixpkgs.config.allowUnfreePredicate = predicate;

     #You have set either `nixpkgs.config` or `nixpkgs.overlays` while using `home-manager.useGlobalPkgs`.
     #This will soon not be possible. Please remove all `nixpkgs` options when using `home-manager.useGlobalPkgs`. 
     #   homeManager.base = _args: {
     #     nixpkgs.config = {
     #       allowUnfreePredicate = predicate;
     #     };
     #   };
      };

    meta.nixpkgs.allowedUnfreePackages = config.nixpkgs.allowedUnfreePackages;
  };

}