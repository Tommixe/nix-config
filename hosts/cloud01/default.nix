{
  imports = [
    ./services
    ./hardware-configuration.nix

    ../common/global
    ../common/users/user01
    ../common/optional/fail2ban.nix
    ../common/optional/ephemeral-btrfs.nix
    ../common/optional/docker.nix
    ../common/optional/dockge.nix
    ../common/optional/gh-token.nix
    ../common/optional/tailscale-server.nix
    #../common/optional/portainer.nix
  ];

  networking = {
    hostName = "cloud01";
    useDHCP = true;
  };

  # Slows down write operations considerably
  nix.settings.auto-optimise-store = false;

  boot.binfmt.emulatedSystems = [
    "x86_64-linux"
    "i686-linux"
  ];

  system.stateVersion = "23.05";
}
