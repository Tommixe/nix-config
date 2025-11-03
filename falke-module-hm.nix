#Create a module for your home-manager configurations:
{ self, inputs, ... }: {
  flake.homeConfigurations = {
    "user01@lp01" = inputs.home-manager-unstable.lib.homeManagerConfiguration {
      # ... configuration
    };
    
    # ... other configurations
  };
}