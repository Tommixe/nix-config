{
  config,
  ...
}:
{
  nixosHosts.cloud01 = {
    unstable = false;
    modules = [
    ];
  };

  flake.modules.nixos.host_cloud01 = {
    imports =
      # Import the nixos modules for the host `cloud01`.
      with config.flake.modules.nixos; [
        fail2ban
        ephemeral-btrfs
        docker
        #dockge
        gh-token
        tailscale-server
        tailscale-exit-node
        msmtp
        nginx
        postgres
        zabbix-server
        hydra-cloud
        hydra-machines
        acme
        binary-cache-cloud
        pii
        auto-upgrade
        # portainer commented out
        sops
        imp # optional to enable persistence i.e. create /persist directories to be preserved by impermanence, can be used without ephemeral-btrfs-lvm
        imp-options # This module must be always turn on even if imp is off automatically add persist directories for some services
      ];

    networking = {
      hostName = "cloud01";
      useDHCP = true;
    };

    nixpkgs.config.allowUnfree = true;


    # Slows down write operations considerably
    nix.settings.auto-optimise-store = false;

    boot.binfmt.emulatedSystems = [
      "x86_64-linux"
      "i686-linux"
    ];

    system.stateVersion = "23.05";

  };
}
