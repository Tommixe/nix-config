#https://github.com/joinemm/nix-infra/blob/master/modules/yubikey.nix
#https://joinemm.dev/blog/yubikey-nixos-guide
{
  flake.modules.nixos.yubikey =
    {
      inputs,
      lib,
      pkgs,
      ...
    }:
    let
      userName = inputs.pconf.global-var.user01;
    in
    {
      # Enable smartcard daemon, to read TOPT tokens from yubikey
      services.pcscd.enable = true;

      # Enable u2f over USB, for yubikey auth in browser
      #hardware.u2f.enable = true;

      environment.etc."pkcs11/modules/ykcs11.module".text = ''
        module: ${pkgs.yubico-piv-tool}/lib/libykcs11.so
      '';

      environment.systemPackages = with pkgs; [
        gnupg
        p11-kit
        yubico-piv-tool
        yubikey-personalization
        yubioath-flutter
        yubikey-manager
        cryptsetup
        pcsc-tools
        opensc
      ];

      services.udev.packages = with pkgs; [
        yubikey-personalization
      ];

      #yubikey login / sudo
      security.pam = lib.optionalAttrs pkgs.stdenv.isLinux {
        u2f = {
          enable = true;
          settings = {
            cue = true; # Tells user they need to press the button
            cue_prompt = " Touch the Yubikey to continue...";
            origin = "pam://yubi";

            authfile = pkgs.writeText "u2f-mappings" (
              lib.concatStrings [
                userName
                ":yGOIB1JOu3o/k811aWOKi3RtwodFfNXN33qjkgKvWuyxfX+SirD14d6LMnWABHz4yUfS4UHRgNlPeILm9J3A0w==,KJPIB3ciPdfMD86TdMtHvOyYHel25I6Vcyciq66mXJKgJuthX9k8nJuMhH0JQdD89VT//VX2NKkId7gNxD29+w==,es256,+presence" # keychain
              ]
            );

          };
        };
        services = {
          login.u2fAuth = true;
          sudo = {
            u2fAuth = true;
          };
        };
      };

    };
}
