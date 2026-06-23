# NixOS Configuration

## Overview
Personal NixOS system configuration for user `chai` on an x86_64 laptop with AMD GPU + disabled NVIDIA dGPU. Managed as a flake, synced to a git repo at `~/nixos-config/` via `sync-to-git.sh`.

## Stack
- NixOS (nixos-unstable channel)
- Nix flakes
- i3 window manager
- Alacritty terminal
- Neovim editor
- Zsh + Oh My Zsh (agnoster theme)
- PulseAudio (pipewire disabled)
- Docker

## Key files
- `flake.nix` — flake entry; also defines KeeWeb AppImage package (sha256 placeholder, not yet built)
- `configuration.nix` — main system config: boot, networking, services, packages, users
- `module.nix` — NixOS module for SonicWall Connect Tunnel; wires up capabilities, tmpfiles, DNS workarounds
- `connect-tunnel.nix` — derivation that fetches and installs the SonicWall SMA Connect Tunnel VPN client (binary, unfree)
- `hardware-configuration.nix` — hardware scan output; LUKS disk, UEFI boot
- `programs/` — program-specific configs split by category

## programs/ layout
```
programs/
  custom-built/   dotnet, exodus, fzf, grip, keeweb, sonicwall
  editor/neovim/  init.vim
  file-manager/vifm/
  git/git/
  scripts/batt-check.py
  shell/zsh/
  terminal/alacritty/   default-settings.nix (generates alacritty.toml)
  window-manager/i3/
```

## Commands
```bash
# Rebuild and switch (run as root or with sudo)
sudo nixos-rebuild switch --flake /etc/nixos#my-nixos

# Rebuild without switching (test)
sudo nixos-rebuild test --flake /etc/nixos#my-nixos

# Sync config to git repo
bash /etc/nixos/sync-to-git.sh

# Restore from git repo
bash /etc/nixos/restore-to-etc-nixos.sh

# Check flake
nix flake check /etc/nixos
```

## Gotchas
- KeeWeb in `flake.nix` has a zeroed sha256 placeholder — `nix-prefetch-url` needed before it builds
- `module.nix` has duplicate `tmpfiles` rules for `/etc/resolv.conf` and `/run/systemd/resolve/resolv.conf` symlinks — acceptable but noisy
- NVIDIA completely blacklisted for battery life; AMD iGPU only
- `environment.variables.DUMMY_FORCE_REBUILD = "true"` exists solely to force a rebuild when needed; safe to change value
- SonicWall DNS workaround: `/etc/resolv.conf` and both `systemd-resolved` paths are symlinked to a user-writable file at `/home/chai/.sonicwall/AventailConnect/tmp/resolv.conf`
- `system.stateVersion = "24.05"` — do not change

## TODO
