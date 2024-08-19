{ config, ... }:
{
  nix.extraOptions = ''!include ${config.sops.templates."nix-extra-config".path} '';
  nix.checkConfig = false;
  users.groups.nix-access-tokens = { };
  sops.templates."nix-extra-config" = {
    content = ''
      access-tokens = github.com=${config.sops.placeholder.github-token}
    '';
    group = config.users.groups.nix-access-tokens.name;
    mode = "0440";
  };
  #users.groups.nix-access-tokens.gid = config.ids.gids.nix-access-tokens;
  sops.secrets.github-token = {
    sopsFile = ../secrets.yaml;
    restartUnits = [ "nix-daemon.service" ];
  };
}
