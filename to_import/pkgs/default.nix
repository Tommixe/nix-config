{
  pkgs ? import <nixpkgs> { },
}:
rec {

  # Personal scripts
  xpo = pkgs.callPackage ./xpo { };
  rstart = pkgs.callPackage ./rstart { };

  # My slightly customized plymouth theme, just makes the blue outline white
  plymouth-spinner-monochrome = pkgs.callPackage ./plymouth-spinner-monochrome { };
}
