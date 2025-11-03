{
  imports = [
    ../../common/optional/nginx.nix
    ../../common/optional/postgres.nix
    ../../common/optional/gh-token.nix
    ../../common/optional/zabbix-server.nix

    ./binary-cache.nix
    ./hydra
  ];
}
