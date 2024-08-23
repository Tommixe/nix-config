{ lib, config, ... }:
let
   obfuscate =
    email: lib.strings.concatStrings (lib.reverseList (lib.strings.stringToCharacters email));
in
{
  # Enable acme for usage with nginx vhosts
  security.acme = {
    defaults.email = obfuscate "ti.orez@emca";
    acceptTerms = true;
  };

  environment.persistence = {
    "/persist" = {
      directories = [ "/var/lib/acme" ];
    };
  };
}
