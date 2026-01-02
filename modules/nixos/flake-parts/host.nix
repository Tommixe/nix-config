#https://github.com/GaetanLepage/nix-config/blob/master/modules/flake/hosts.nix
{
  inputs,
  lib,
  config,
  ...
}:
let
  inherit (lib) types mkOption;
in
{
  options =
    let
      baseHostModule =
        { config, ... }:
        {
          options = {
            system = mkOption {
              type = types.str;
              default = "x86_64-linux";
            };

            unstable = lib.mkOption {
              type = types.bool;
            };

            modules = lib.mkOption {
              type = with types; listOf deferredModule;
              default = [ ];
            };

            nixpkgs = lib.mkOption {
              type = types.pathInStore;
            };

            pkgs = lib.mkOption {
              type = types.pkgs;
            };

            home-manager = lib.mkOption {
              type = types.pathInStore;
            };


          };
          config = {
            nixpkgs = if config.unstable then inputs.nixpkgs-unstable else inputs.nixpkgs;
            home-manager = if config.unstable then  inputs.home-manager-unstable else  inputs.home-manager;
            #modules = if config.unstable then [inputs.home-manager-unstable.nixosModules.default ] else  [inputs.home-manager.nixosModules.default ];
            pkgs = import config.nixpkgs {
              inherit (config) system;
              config.allowUnfree = true;
            };
          };
        };

      hostTypeNixos = types.submodule [
        baseHostModule
        (
          { name, ... }:
          {
            modules = [
              config.flake.modules.nixos.base
              { networking.hostName = name; }
              (config.flake.modules.nixos."host_${name}" or { })
              #inputs.home-manager-unstable.nixosModules.default           
            ];
          }
        )
      ];
      hostTypeHomeManager = types.submodule [
        baseHostModule
        {
          modules = [
            #config.flake.modules.homeManager.base
            (
              { pkgs, config, ... }:
              {
                nix.package = pkgs.nix;
                #age.identityPaths = [ "${config.home.homeDirectory}/.ssh/agenix" ];
              }
            )
          ];
        }
      ];
    in
    {
      nixosHosts = mkOption { type = types.attrsOf hostTypeNixos; };
      homeHosts = mkOption { type = types.attrsOf hostTypeHomeManager; };
    };

  config = {
    flake = {
      nixosConfigurations =
        let
          mkHost =
            hostname: options:

            options.nixpkgs.lib.nixosSystem {
              inherit (options) system ;
              specialArgs.inputs = inputs;
               modules = options.modules ++ [
                # Additional module here
                
                 options.home-manager.nixosModules.default
                
              ];
            };
        in
        lib.mapAttrs mkHost config.nixosHosts;

      homeConfigurations =
        let
          mkHost =
            configName: options:
            options.home-manager.lib.homeManagerConfiguration {
              extraSpecialArgs = {
                inputs = inputs;
                inherit configName;
                nhSwitchCommand = "nh home switch --configuration ${configName}";
              };
              inherit (options) pkgs modules;
            };
        in
        lib.mapAttrs mkHost config.homeHosts;
    };
  };
}
