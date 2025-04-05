{
  lib,
  ...
}:
{

  options =  {    
    global-var = lib.mkOption {
      description = "Attribute set with PII variables";
      type = lib.types.attrs;
    };
  };

  config = {
   global-var = {}; #builtins.extraBuiltins.sopsImportEncrypted ../global-var.nix.sops;
  };

}