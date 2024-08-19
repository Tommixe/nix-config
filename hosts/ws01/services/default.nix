{
  imports = [
    # ../../common/optional/nginx.nix
    # ../../common/optional/postgres.nix
    ../../common/optional/gh-token.nix

    ./qemuguest.nix
    # ./binary-cache.nix
    # ./hydra
  ];
}
