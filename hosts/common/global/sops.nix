{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  isEd25519 = k: k.type == "ed25519";
  getKeyPath = k: k.path;
  keys = builtins.filter isEd25519 config.services.openssh.hostKeys;
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    age.sshKeyPaths = map getKeyPath keys;
  };

  environment.variables = {
    SOPS_AGE_KEY_FILE="/run/secrets.d/age-keys.txt";
  };

  environment.systemPackages = [pkgs.sops ];

}
