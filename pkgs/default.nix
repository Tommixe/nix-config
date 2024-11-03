{
  pkgs ? import <nixpkgs> { },
}:
rec {

  # Personal scripts
  pass-wofi = pkgs.callPackage ./pass-wofi { };
  xpo = pkgs.callPackage ./xpo { };

  # My slightly customized plymouth theme, just makes the blue outline white
  plymouth-spinner-monochrome = pkgs.callPackage ./plymouth-spinner-monochrome { };
}
