{ pkgs, config, ... }:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{

  users.groups.multimedia = { };

  users.mutableUsers = false;
  users.users.multimedia = {
    isNormalUser = true;
    extraGroups =
      [
        "video"
        "audio"
        "multimedia"
      ]
      ++ ifTheyExist [
        "tommaso"
        "deluge"
      ];
  };
}
