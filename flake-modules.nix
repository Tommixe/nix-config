### mkdir -p ./flake-modules
#Create a module for your NixOS configurations:

{ self, inputs, ... }: {
  flake.nixosConfigurations = {
    hpx360 = inputs.nixpkgs.lib.nixosSystem {
      modules = [ ../hosts/hpx360 ];
      specialArgs = { inherit inputs; };
    };

    lp01 = inputs.nixpkgs-unstable.lib.nixosSystem {
      modules = [ ../hosts/lp01 ];
      specialArgs = { inherit inputs; };
    };
    
    # ... other configurations
  };
}