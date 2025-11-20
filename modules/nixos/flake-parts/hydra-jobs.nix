#https://github.com/hyperparabolic/nix-config/blob/main/modules/flake-parts/hydra-jobs.nix
{
  self,
  inputs,
  ...
}:
let
  inherit (inputs.nixpkgs) lib;
in
{
  flake =
    let
      inherit (self) outputs;
    in
    {
      hydraJobs = {
        hosts =
          outputs.nixosConfigurations
          # remove iso, I don't need it every build
          |> lib.filterAttrs (n: _v: !builtins.elem n [ "iso" ])
          # add to my jobs dashboard and set up evaluation error notifications
          |> lib.mapAttrs (
            _: cfg:
            lib.addMetaAttrs { maintainers = [ "email@nt.it" ]; } cfg.config.system.build.toplevel
          );
      };
    };
}
