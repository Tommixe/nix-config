# NixOS Configuration Summary

Multi-host declarative NixOS + Home Manager setup. Currently ~12 hosts: lp01, hpx360, ws01/02, server01/02, cloud01, dev01, rpi01, lxc01/02.

## Flake Structure

`flake.nix` uses `flake-parts` + `import-tree` to auto-discover modules under `modules/`. Inputs include nixpkgs (26.05 + unstable), home-manager (stable + unstable), sops-nix, impermanence, disko, hermes-agent, nixos-hardware, nix-colors, hyprwm-contrib, etc.

Per-system overlays in `modules/nixos/flake-parts/nixpkgs.nix` expose `pkgs.unstable` and `pkgs.master` packages. Hydra jobs auto-generated from `nixosConfigurations` and `packages`.

## Hosts

| Host | Type | Hardware | Key Services |
|------|------|----------|--------------|
| **cloud01** | Oracle VPS | Ampere aarch64, 24GB/4vCPU | docker, nginx, postgres, zabbix, **hydra-cloud**, tailscale exit-node |
| **dev01** | HyperV VM | x86_64 | docker, portainer, ephemeral-btrfs |
| **hpx360** | HP x360 laptop | i3-5010U, 8GB | GNOME, pipewire, wireless |
| **lp01** | Laptop | AMD/NVMe, x86_64 | GNOME/Cosmic, flatpak, yubikey, virt-manager, hermes-agent |
| **lxc01** | Proxmox LXC | — | jellyfin, radarr/sonarr/lidarr, transmission, jackett |
| **lxc02** | Proxmox LXC | — | nextcloud-aio, docker, portainer, acme |
| **rpi01** | Raspberry Pi 3B | aarch64, 4GB | tailscale, wireless |
| **server01** | HyperV VM | x86_64 | jellyfin/arr stack, duplicacy, NFS mounts |
| **server02** | HyperV VM | x86_64 | docker/dockge, kasm (partial) |
| **ws01** | HyperV VM | x86_64 | GNOME, docker/dockge, RDP (3389), kdeconnect |
| **ws02** | Physical desktop | x86_64 | GNOME, hydra-local/binary-cache, postgres, WOL |

## Base Modules (applied to all)

**NixOS base** (`modules/nixos/base/`): auto-upgrade (hydra-driven), fish, locale (en_US + it_IT, Europe/Rome), nh (cleaner), nix (settings, gc, registry, cache substituters), openssh (with persisted ed25519 host keys), tailscale, zabbix-agent.

**Home Manager base** (`modules/home-manager/base/`): bash, bat, cli-pkgs (~20 CLI tools), direnv, fish, gh, git, hm, ssh, starship.

## Optional NixOS Modules (`modules/nixos/optional/`)

- **acme** — ACME certs
- **binary-cache(-cloud/-local)** — local + remote substituters
- **cosmic** — Cosmic desktop
- **docker / podman** — OCI containers
- **dockge** — docker compose UI
- **duplicacy** — backups
- **encrypted-root** — LUKS
- **ephemeral-btrfs(-lvm)** — impermanent root on btrfs (+ LVM)
- **fail2ban**
- **flatpak**
- **gamemode**
- **gh-token**
- **gnome**
- **hermes** — Nous Hermes agent (LLM container)
- **hydra(-cloud/-local/-machine)** — CI / Nix build farm
- **incus** — system containers/VMs
- **jackett, lidarr, prowlarr, radarr, sonarr** — *arr stack (media management)
- **jellyfin** — media server
- **kde**
- **msmtp** — outbound SMTP
- **mysql, postgres** — databases
- **nextcloud-aio** — self-hosted cloud
- **nginx**
- **pavucontrol, pipewire** — audio
- **portainer** — container management
- **printerhp**
- **quietboot**
- **rstart** — custom module
- **ssh-serve-store** — SSH nix-store access
- **systemd-boot, systemd-initrd**
- **tailscale-exit-node, tailscale-server(-local)**
- **transmission**
- **virt-manager**
- **wirelesspersist**
- **xbootldr**
- **yubikey**
- **zabbix-server**

## Impermanence

`modules/nixos/impermanence/`: opt-in `/persist` directory persisted across reboots. Base dirs (`/var/log`, `/var/lib/systemd`, etc.) always persisted; per-module extensions via `custom.imp.{root,home}.directories`. Works with btrfs snapshots, tmpfs, or regular root.

## Secrets

`sops-nix` with per-host age keys defined in `.sops.yaml`. `modules/secrets/pii.nix` exposes personal info from external `pconf` input. Per-host `secrets.yaml` files encrypted with host's age key + user's age key.

## Home Manager Modules

`modules/home-manager/`: deluge, dragon, ente-auth, fastfetch, firefox (profile + extensions), flatpaks, font (FiraCode/Sans), ghostty, gnome-extensions, helix, kdeconnect, onedriver, pavucontrol, playerctl, ranger. `base/` provides shell/user tooling.

## Hermes Agent

`modules/nixos/optional/hermes/` deploys Nous Hermes as a containerized LLM agent. OpenRouter provider, kawaii personality, sops-encrypted env file.

## Custom Modules

`modules/nixos/my-modules/`: duplicacy(-prune), garage-s3, hydra-auto-upgrade, opencloud, rstart, rsync-scheduled. `modules/pkgs/`: custom package builds.

## CI/CD

Hydra on cloud01 (`.hydra.json`) builds `main` and `next` branches. Auto-upgrade module pulls latest hydra build.

## Dev Shell

`shell.nix` provides nix, home-manager, git, sops, ssh-to-age, gnupg, age for bootstrapping.

## Secrets (.sops.yaml)

Per-host age keys for 11 hosts + user key. Path-based encryption rules ensure each host's secrets are decryptable only by that host + user.

Repo scope: full NixOS infrastructure (system + home + secrets + CI), not application-level.
