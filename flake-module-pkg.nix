#Then create a module for your packages:
{ self, inputs, ... }: {
  perSystem = { pkgs, ... }: {
    packages = import ../pkgs { inherit pkgs; };
    devShells = import ../shell.nix { inherit pkgs; };
  };
}