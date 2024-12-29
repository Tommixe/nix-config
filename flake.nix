{
  description = "My NixOS configuration";

  nixConfig = {
    #extra-substituters = [ "https://cache.tzero.it"  "https://cache.nixos.org" "https://cachecloud.tzero.it"  ];
    #extra-trusted-public-keys = [ "cache.tzero.it:C3XpjhEEHIEz9Ygh5ZjTlv7Gh4a0In09hY66hmssDls=" "cachecloud.tzero.it:C3XpjhEEHIEz9Ygh5ZjTlv7Gh4a0In09hY66hmssDls="];
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
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    hardware.url = "github:nixos/nixos-hardware";
    impermanence.url = "github:nix-community/impermanence";
    nix-colors.url = "github:misterio77/nix-colors";
    sops-nix.url = "github:mic92/sops-nix";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    nix-flatpak.url = "github:gmodena/nix-flatpak/main";
    #disko.inputs.nixpkgs-stable.follows = "nixpkgs";

    home-manager = {
      #url = "github:nix-community/home-manager";
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprwm-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-flatpak,
      ghostty,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forEachSystem = f: lib.genAttrs systems (sys: f pkgsFor.${sys});
      pkgsFor = nixpkgs.legacyPackages;
    in
    {
      inherit lib;
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;
      #templates = import ./templates;

      overlays = import ./overlays { inherit inputs outputs; };
      hydraJobs = import ./hydra.nix { inherit inputs outputs; };

      packages = forEachSystem (pkgs: import ./pkgs { inherit pkgs; });
      #devShells = forEachSystem (pkgs: import ./shell.nix { inherit pkgs; });
      formatter = forEachSystem (pkgs: pkgs.nixfmt-rfc-style);

      #wallpapers = import ./home/misterio/wallpapers;
      wallpapers = import ./home/user01/wallpapers;

      nixosConfigurations = {
        #HP laptop
        hpx360 = lib.nixosSystem {
          modules = [ ./hosts/hpx360 ];
          specialArgs = {
            inherit inputs outputs;
          };
        };
        # Server on HP G440 (Main server)
        server01 = lib.nixosSystem {
          modules = [ ./hosts/server01 ];
          specialArgs = {
            inherit inputs outputs;
          };
        };
        # Server02
        server02 = lib.nixosSystem {
          modules = [ ./hosts/server02 ];
          specialArgs = {
            inherit inputs outputs;
          };
        };
        # ws01
        ws01 = lib.nixosSystem {
          modules = [ ./hosts/ws01 ];
          specialArgs = {
            inherit inputs outputs;
          };
        };
        # local VM to experiment
        dev01 = lib.nixosSystem {
          modules = [ ./hosts/dev01 ];
          specialArgs = {
            inherit inputs outputs;
          };
        };
        # Arm VPS on oracle cloud 
        cloud01 = lib.nixosSystem {
          modules = [ ./hosts/cloud01 ];
          specialArgs = {
            inherit inputs outputs;
          };
        };
        # Raspberry pi 3 
        rpi01 = lib.nixosSystem {
          modules = [ ./hosts/rpi01 ];
          specialArgs = {
            inherit inputs outputs;
          };
        };
        # Proxmox lxc container
        lxc01 = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./hosts/lxc01 ];
          specialArgs = {
            inherit inputs outputs;
          };
        };
        # Proxmox lxc container
        lxc02 = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./hosts/lxc02 ];
          specialArgs = {
            inherit inputs outputs;
          };
        };
        # ws02
        ws02 = lib.nixosSystem {
          modules = [ ./hosts/ws02 ];
          specialArgs = {
            inherit inputs outputs;
          };
        };
      };

      homeConfigurations = {
        # Desktops
        "user01@dev01" = lib.homeManagerConfiguration {
          modules = [ ./home/user01/dev01.nix ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs;
          };
        };
        "user01@server01" = lib.homeManagerConfiguration {
          modules = [ ./home/user01/server01.nix ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs;
          };
        };
        "user01@server02" = lib.homeManagerConfiguration {
          modules = [ ./home/user01/server02.nix ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs;
          };
        };
        "user01@hpx360" = lib.homeManagerConfiguration {
          modules = [ ./home/user01/hpx360.nix ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs;
          };
        };
        "user01@ws01" = lib.homeManagerConfiguration {
          modules = [ ./home/user01/ws01.nix ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs;
          };
        };
        "user01@cloud01" = lib.homeManagerConfiguration {
          modules = [ ./home/user01/cloud01.nix ];
          pkgs = pkgsFor.aarch64-linux;
          extraSpecialArgs = {
            inherit inputs outputs;
          };
        };
        "user01@rpi01" = lib.homeManagerConfiguration {
          modules = [ ./home/user01/rpi01.nix ];
          pkgs = pkgsFor.aarch64-linux;
          extraSpecialArgs = {
            inherit inputs outputs;
          };
        };
        "user01@lxc01" = lib.homeManagerConfiguration {
          modules = [ ./home/user01/lxc01.nix ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs;
          };
        };
        "user01@lxc02" = lib.homeManagerConfiguration {
          modules = [ ./home/user01/lxc02.nix ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs;
          };
        };
        "user01@ws02" = lib.homeManagerConfiguration {
          modules = [ ./home/user01/ws02.nix ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs;
          };
        };

      };
    };
}
