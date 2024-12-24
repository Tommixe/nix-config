# This file (and the global directory) holds config that i use on all hosts
# This file is only for contatiner LXC, still to decide if to make onyl one
#
# Source: https://discourse.nixos.org/t/cannot-set-file-attributes-for-var-empty/35129/14 
# IMPORTANT on proxmox host run for every lxc:
# root@pve-1:~# pct mount 102
# mounted CT 102 in '/var/lib/lxc/102/rootfs'
# root@pve-1:~# chattr +i /var/lib/lxc/102/rootfs/var/empty
# root@pve-1:~# pct unmount 102


{ inputs, outputs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./acme.nix
    ./auto-upgrade.nix
    ./fish.nix
    ./locale.nix
    ./nix.nix
    ./openssh.nix
    ./optin-persistence.nix
    #./podman.nix
    ./sops.nix
    ./ssh-serve-store.nix
    #./steam-hardware.nix
    #./systemd-initrd.nix
    ./tailscale.nix
    ./zabbix-agent.nix
  ] ++ (builtins.attrValues outputs.nixosModules);

  home-manager.extraSpecialArgs = {
    inherit inputs outputs;
  };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
      # FIXME
      permittedInsecurePackages = [ "openssl-1.1.1u" ];
    };
  };

  environment.enableAllTerminfo = true;

  hardware.enableRedistributableFirmware = true;
  #networking.domain = "m7.rs";

  # Commenting because it is not working with LXC container
  # It is impossible to login
  /*
  # Increase open file limit for sudoers
  security.pam.loginLimits = [
    {
      domain = "@wheel";
      item = "nofile";
      type = "soft";
      value = "524288";
    }
    {
      domain = "@wheel";
      item = "nofile";
      type = "hard";
      value = "1048576";
    }
  ];
  */
}
