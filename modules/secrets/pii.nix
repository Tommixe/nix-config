{
  flake.modules.nixos.pii =
    {
      lib,
      inputs,
      ...
    }:
    {

      options = {
        global-var = lib.mkOption {
          description = "Attribute set with PII variables";
          type = lib.types.attrs;
        };
      };

      config = {
        global-var = inputs.pconf.global-var;
      };

    };
}
