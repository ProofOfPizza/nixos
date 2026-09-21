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
- `flake.nix` — flake entry; also carries a dead KeeWeb stub (see Gotchas)
- `configuration.nix` — main system config: boot, networking, services, packages, users
- `module.nix` — NixOS module for SonicWall Connect Tunnel; wires up capabilities, tmpfiles, DNS workarounds
- `connect-tunnel.nix` — derivation that fetches and installs the SonicWall SMA Connect Tunnel VPN client (binary, unfree)
- `hardware-configuration.nix` — hardware scan output; LUKS disk, UEFI boot
- `qobuz-creds.py` — regenerates the Qobuz App ID / App Secret for Strawberry (see Gotchas)
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

# Regenerate Qobuz App ID + Secret for Strawberry
python3 /etc/nixos/qobuz-creds.py
```

## Gotchas
- **KeeWeb is self-maintained and load-bearing.** Removed from nixpkgs 2026-09 (EOL Electron; upstream dead since 1.18.7, Jul 2021). Now built locally from `programs/custom-built/keeweb/keeweb.nix`, pinned to 1.18.7. Do not swap for KeePassXC: keeweb syncs the db to Nextcloud over its own WebDAV client (there is no `~/Nextcloud` folder and the Nextcloud desktop client is not running — the WebDAV client *is* the sync), and its global shift-alt-b/c copy hotkeys have no KeePassXC equivalent (KeePassXC has only one global shortcut, Auto-Type).
- **KeeWeb breaks on nixpkgs bumps — check `extraPkgs` first.** The AppImage runs in an `appimageTools.wrapType2` FHS env; as nixpkgs' default Electron lib set drifts, libs silently drop out. Symptom is `error while loading shared libraries: <lib>.so.N` on launch. Fix: add the lib to `extraPkgs` in `keeweb.nix`. Already needed: `libsecret`, `libxshmfence`. Do not diagnose with `ldd` on the extracted binary — it runs outside the sandbox and reports ~30 false positives the FHS actually provides; trust the runtime error message instead.
- Test keeweb from `~`, not `/etc/nixos` — bwrap can't chdir into a path absent from the sandbox (`bwrap: Can't chdir to /etc/nixos`). Fontconfig `invalid attribute 'xsi:nil'` spam on launch is cosmetic (bundled fontconfig is older than `/etc/fonts`).
- The KeeWeb stub in `flake.nix` (v1.18.7, zeroed sha256, broken `installPhase`) is dead code — superseded by `programs/custom-built/keeweb/keeweb.nix`. The darwin hashes in that file are still 1.16.7 and wrong; harmless on x86_64-linux (lazy eval never selects them).
- **Qobuz in Strawberry needs credentials that expire.** `qbz` was removed from nixpkgs 2026-09 (source pulled upstream, no replacement). Qobuz now runs through `strawberry`, whose Qobuz support is unofficial: it needs an App ID + App Secret that Qobuz does not publish. Run `python3 /etc/nixos/qobuz-creds.py` (stdlib only, no deps) to scrape them from the web player's `bundle.js`. It prints one App ID and ~3 secret candidates; enter them in Strawberry under Tools → Settings → Qobuz. **These rotate whenever Qobuz redeploys their player** — if playback dies months from now, re-run the script before suspecting Strawberry.
  - Login succeeding does not validate the secret; the secret only signs playback URL requests. `Invalid Request Signature` on play = right token, wrong secret → try the next candidate.
  - If the script itself fails ("bundle.js URL not found" / "regex is stale"), Qobuz changed their page layout; upstream logic lives in `qobuz_dl/bundle.py` in vitiko98/qobuz-dl.
  - Symptom of a *working* setup that still shows nothing: `enabled=false` in the `[Qobuz]` section of `~/.config/strawberry/strawberry.conf`. The service toggle is separate from login. Toggle it in the UI — Strawberry rewrites that file on exit and will clobber hand-edits.
- `module.nix` has duplicate `tmpfiles` rules for `/etc/resolv.conf` and `/run/systemd/resolve/resolv.conf` symlinks — acceptable but noisy
- NVIDIA completely blacklisted for battery life; AMD iGPU only
- `environment.variables.DUMMY_FORCE_REBUILD = "true"` exists solely to force a rebuild when needed; safe to change value
- SonicWall DNS workaround: `/etc/resolv.conf` and both `systemd-resolved` paths are symlinked to a user-writable file at `/home/chai/.sonicwall/AventailConnect/tmp/resolv.conf`
- `system.stateVersion = "24.05"` — do not change

## TODO
