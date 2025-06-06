[![built with nix](https://img.shields.io/static/v1?logo=nixos&logoColor=white&label=&message=Built%20with%20Nix&color=41439a)](https://builtwithnix.org)
[![hydra status](https://img.shields.io/endpoint?url=https://hydracloud.tzero.it/job/nix-config/main/hosts.cloud01/shield)](https://hydracloud.tzero.it/jobset/nix-config/main#tabs-jobs)

# My NixOS configurations

Here's my NixOS/home-manager config files. Requires [Nix flakes](https://nixos.wiki/wiki/Flakes).
Started and heavly inspired by https://github.com/Misterio77/nix-config

**Highlights**:

- Multiple **NixOS configurations**, including **desktop**, **laptop**, **server**
- **Opt-in persistence** through impermanence + blank snapshotting.
- **Encrypted** single **BTRFS** partition.
- Fully **declarative** **self-hosted** stuff
- Deployment **secrets** using **sops-nix**
- **Mesh networked** hosts with **tailscale** and **headscale**
- Flexible **Home Manager** Configs through **feature flags**
- Extensively configured wayland environments (**sway** and **hyprland**) and editor (**neovim**)
- **Declarative** **themes** and **wallpapers** with **nix-colors**
- **Hydra CI/CD server and binary cache** that uses the **desktops as remote builders**

## Structure

- `flake.nix`: Entrypoint for hosts and home configurations. Also exposes a
  devshell for boostrapping (`nix develop` or `nix-shell`).
- `lib`: A few lib functions for making my flake cleaner.
- `hosts`: NixOS Configurations, accessible via `nixos-rebuild --flake`.
  - `common`: Shared configurations consumed by the machine-specific ones.
    - `global`: Configurations that are globally applied to all my machines.
    - `optional`: Opt-in configurations my machines can use
  - `hpx360`: Laptop HP x360 - 8GB RAM, i3-5010U | Gnome
  - `ws01`: VM on proxmox node MOX - 8GB RAM | Gnome
  - `server01`: VM on proxmox node MOX  - 8GB RAM | Server
  - `rp01`: Raspberry Pi 3B - 4GB RAM | Server (to be teseted)
  - `cloud01`: Oracle Could VPS (Ampere) - 24GB RAM & 4vCPUs | Server
  - `server02`: VM on proxmox node PVE  - 8GB RAM | Server
- `home`: My Home-manager configuration, acessible via `home-manager --flake`
    - Each directory here is a "feature" each hm configuration can toggle, thus
      customizing my setup for each machine (be it a server, desktop, laptop,
      anything really).
- `modules`: A few actual modules (with options) I haven't upstreamed yet.
- `overlay`: Patches and version overrides for some packages. Accessible via
  `nix build`.
- `pkgs`: My custom packages. Also accessible via `nix build`. You can compose
  these into your own configuration by using my flake's overlay, or consume them through NUR.
- `templates`: A couple project templates for different languages. Accessible
  via `nix init`



## About the installation

All my computers use a single btrfs (encrypted on all except headless systems)
partition, with subvolumes for `/nix`, a `/persist` directory (which I opt in
using `impermanence`), swap file, and a root subvolume (cleared on every boot).

Home-manager is used in a standalone way, and because of opt-in persistence is
activated on every boot with `loginShellInit`.


## How to bootstrap

All you need is nix (any version). Run:
```
nix-shell
```

If you already have nix 2.4+, git, and have already enabled `flakes` and
`nix-command`, you can also use the non-legacy command:
```
nix develop
```

`nixos-rebuild --flake .` To build system configurations

`home-manager switch --flake .` To build user configurations

`nix build` (or shell or run) To build and use packages

`sops` To manage secrets


## Secrets

For deployment secrets (such as user passwords and server service secrets), I'm
using the awesome [`sops-nix`](https://github.com/Mic92/sops-nix). All secrets
are encrypted with my personal PGP key (stored on a YubiKey), as well as the
relevant systems's SSH host keys.

To set users' password
echo "password" | mkpasswd -s -m sha-512
and copy the generated hash in the host/common/secrets.yaml file

On my desktop and laptop, I use `pass` for managing passwords, which are
encrypted using (you bet) my PGP key. This same key is also used for mail
signing, as well as for SSH'ing around.

## Tooling and applications I use

Most relevant user apps daily drivers:

- hyprland + swayidle + swaylock
- waybar
- neovim
- fish + starship
- kitty
- qutebrowser
- neomutt + mbsync
- khal + khard + todoman + vdirsyncer
- gpg + pass
- tailscale
- podman
- zathura
- wofi
- bat + fd + rg
- kdeconnect
- sublime-music

Some of the services I host:

- hydra
- navidrome
- deluge
- prometheus
- websites
- minecraft
- headscale

Nixy stuff:

- nix-colors
- sops-nix
- impermanence
- home-manager
- deploy-rs
- and NixOS and nix itself, of course :)

Let me know if you have any questions about them :)

## Steps
- nix flake check --no-build
- nix fmt . -- --check

## To update pconf input
 sudo nix flake update pconf
