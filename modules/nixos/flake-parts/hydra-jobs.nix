#https://github.com/hyperparabolic/nix-config/blob/main/modules/flake-parts/hydra-jobs.nix
{
  self,
  inputs,
  ...
}:
{
  flake =
    let
      inherit (self) outputs;
      inherit (inputs.nixpkgs.lib) filterAttrs mapAttrs elem;

      notBroken = pkg: !(pkg.meta.broken or false);
      hasPlatform = sys: pkg: elem sys (pkg.meta.platforms or [ ]);
      filterValidPkgs = sys: pkgs: filterAttrs (_: pkg: hasPlatform sys pkg && notBroken pkg) pkgs;
      getCfg = _: cfg: cfg.config.system.build.toplevel;
    in
    {

      hydraJobs = {
        pkgs = mapAttrs filterValidPkgs outputs.packages;
        hosts = mapAttrs getCfg outputs.nixosConfigurations;
      };
    };
}
