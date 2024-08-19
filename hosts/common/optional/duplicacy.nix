{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.duplicacy ];
}
