{
  description = "My NixOS configuration";

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://cachecloud.tzero.it"
    ];
    extra-trusted-public-keys = [
      "cachecloud.tzero.it:0d35aEumDjIuR27iqi5FgnFPmM1ppRpsu43aQx6xcpM="
      "cache.tzero.it:C3XpjhEEHIEz9Ygh5ZjTlv7Gh4a0In09hY66hmssDls="
    ];
  };

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    import-tree.url = "github:vic/import-tree";
    
    # Keep your existing inputs
    hardware.url = "github:nixos/nixos-hardware";
        
    impermanence.url = "github:nix-community/impermanence";
    nix-colors.url = "github:misterio77/nix-colors";
    sops-nix.url = "github:mic92/sops-nix";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    nix-flatpak.url = "github:gmodena/nix-flatpak/main";
    nixos-facter-modules.url = "github:nix-community/nixos-facter-modules";
    #disko.inputs.nixpkgs-stable.follows = "nixpkgs";
    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";

    home-manager = {
      #url = "github:nix-community/home-manager";
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    hyprwm-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pconf = {
      #url = "git+ssh://git@github.com/Tommixe/nixos-pconf";
      url = "github:Tommixe/nixos-pconf";
    };


  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

/*
  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" ];
      
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        # Per-system attributes
        packages = import ./pkgs { inherit pkgs; };
        devShells = import ./shell.nix { inherit pkgs; };
        formatter = pkgs.nixfmt-rfc-style;
      };

      flake = {
        nixosConfigurations = {
          # HP laptop
          hpx360 = inputs.nixpkgs.lib.nixosSystem {
            modules = [ ./hosts/hpx360 ];
            specialArgs = { inherit inputs; };
          };
          
          # Lenovo AMD laptop using unstable
          lp01 = inputs.nixpkgs-unstable.lib.nixosSystem {
            modules = [ ./hosts/lp01 ];
            specialArgs = { inherit inputs; };
          };
          
          # ...other systems...
        };

        homeConfigurations = {
          "user01@lp01" = inputs.home-manager-unstable.lib.homeManagerConfiguration {
            # ...configuration...
          };
          # ...other home configurations...
        };

        # Your existing outputs
        nixosModules = import ./modules/nixos;
        homeManagerModules = import ./modules/home-manager;
        overlays = import ./overlays { inherit inputs; };
        hydraJobs = import ./hydra.nix { inherit inputs; };
        wallpapers = import ./home/user01/wallpapers;
      };
    };
    */
}