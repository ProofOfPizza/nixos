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

# Deploy dotfiles from programs/ to ~ (nvim, i3, vifm, zsh, git, flameshot)
sudo bash /etc/nixos/copy-config.sh

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
- **Dotfiles in `programs/` are not live until `copy-config.sh` runs.** It copies them into `~` with plain `cp`; a rebuild does not deploy them. Editing only the `/etc/nixos` copy looks like a fix but changes nothing: e.g. nvim loads `~/.config/nvim/init.vim` after the system `customRC`, so the stale home copy wins. `programs/**/default.nix` files with `home.file` are dead (home-manager is not in use).
- **KeeWeb is self-maintained and load-bearing.** Removed from nixpkgs 2026-09 (EOL Electron; upstream dead since 1.18.7, Jul 2021). Now built locally from `programs/custom-built/keeweb/keeweb.nix`, pinned to 1.18.7. Do not swap for KeePassXC: keeweb syncs the db to Nextcloud over its own WebDAV client (there is no `~/Nextcloud` folder and the Nextcloud desktop client is not running — the WebDAV client *is* the sync), and its global shift-alt-b/c copy hotkeys have no KeePassXC equivalent (KeePassXC has only one global shortcut, Auto-Type).
- **KeeWeb breaks on nixpkgs bumps — check `extraPkgs` first.** The AppImage runs in an `appimageTools.wrapType2` FHS env; as nixpkgs' default Electron lib set drifts, libs silently drop out. Symptom is `error while loading shared libraries: <lib>.so.N` on launch. Fix: add the lib to `extraPkgs` in `keeweb.nix`. Already needed: `libsecret`, `libxshmfence`. Do not diagnose with `ldd` on the extracted binary — it runs outside the sandbox and reports ~30 false positives the FHS actually provides; trust the runtime error message instead.
- Test keeweb from `~`, not `/etc/nixos` — bwrap can't chdir into a path absent from the sandbox (`bwrap: Can't chdir to /etc/nixos`). Fontconfig `invalid attribute 'xsi:nil'` spam on launch is cosmetic (bundled fontconfig is older than `/etc/fonts`).
- The KeeWeb stub in `flake.nix` (v1.18.7, zeroed sha256, broken `installPhase`) is dead code — superseded by `programs/custom-built/keeweb/keeweb.nix`. The darwin hashes in that file are still 1.16.7 and wrong; harmless on x86_64-linux (lazy eval never selects them).
- **Qobuz in Strawberry needs credentials that expire.** `qbz` was removed from nixpkgs 2026-09 (source pulled upstream, no replacement). Qobuz now runs through `strawberry`, whose Qobuz support is unofficial: it needs an App ID + App Secret that Qobuz does not publish. Run `python3 /etc/nixos/qobuz-creds.py` (stdlib only, no deps) to scrape them from the web player's `bundle.js`. It prints one App ID and ~3 secret candidates; enter them in Strawberry under Tools → Settings → Qobuz. **These rotate whenever Qobuz redeploys their player** — if playback dies months from now, re-run the script before suspecting Strawberry.
  - Login succeeding does not validate the secret; the secret only signs playback URL requests. `Invalid Request Signature` on play = right token, wrong secret → try the next candidate.
  - If the script itself fails ("bundle.js URL not found" / "regex is stale"), Qobuz changed their page layout; upstream logic lives in `qobuz_dl/bundle.py` in vitiko98/qobuz-dl.
  - Symptom of a *working* setup that still shows nothing: `enabled=false` in the `[Qobuz]` section of `~/.config/strawberry/strawberry.conf`. The service toggle is separate from login. Toggle it in the UI — Strawberry rewrites that file on exit and will clobber hand-edits.
- `module.nix` has duplicate `tmpfiles` rules for `/etc/resolv.conf` and `/run/systemd/resolve/resolv.conf` symlinks — acceptable but noisy
- **Beamer display keys depend on pixel clock, not resolution.** `xrandr --verbose` shows the clock per mode. Two links, opposite limits:
  - HDMI port (`HDMI-A-0`): only works up to ~150 MHz since 2026-10 (1080p60 yes; 241/297/498 MHz no). Physical degradation of the port or the BlueBuilt cable's laptop end; not the kernel, driver or the 90° adapter (all ruled out). Port vs cable never isolated.
  - USB-C to HDMI cable (`DisplayPort-0`): only works above 340 MHz, i.e. HDMI 2.0 scrambled modes (1440p120, 4K60 yes; 1080p anything and 4K at 24/30 no). Limit of the DP to HDMI converter chip; the beamer itself accepts 1080p60.
  - Hence F7 = 1080p60 (HDMI port fallback), F8 = 1440p120 (normal work state, best film cadence), F9 = 4K60 (4K too small to work in). True 24p is impossible on either link.
  - After beamer standby, 1440p120 can come back as "weak or no signal" while 4K60 still works, and X reports the mode as set. Turning Game Mode off and on again on the beamer fixed it, even though it was already on (seen once, 2026-10-21). An xrandr off/on cycle did not help.
  - `xrandr --mode` without `--rate` picks the first rate in the EDID list, which for this beamer is 120 Hz at 1080p. `xrandr-mirror.sh` takes an optional rate as `$2` for this reason.
  - The mirror scripts pick the first connected non-eDP output, and `HDMI-A-0` sorts before `DisplayPort-*`: with both plugged in, the HDMI port wins.
  - Diagnostic red herrings: `[drm] REG_WAIT timeout ... optc1_wait_for_state` appears hundreds of times in every boot since at least 2026-06, working or not; it is amdgpu noise on Phoenix, not a symptom. A quiet `udevadm monitor --subsystem-match=drm` during a wiggle test only proves the hot-plug pin holds; the TMDS data pairs can degrade while the beamer stays "connected" with valid EDID.
- Kernel is pinned to the 6.6 LTS series (`linuxPackages_6_6`, since 2026-02, commit `cdc660f`). The patch level moves silently with every `flake.lock` update (6.6.143 → 6.6.157 on 2026-09-21). Check `uname -r` and `readlink /nix/var/nix/profiles/system-*-link/kernel` before blaming or exonerating a kernel bump; a long uptime means the running kernel can lag the newest generation by weeks.
- `sync-to-git.sh` needs a real terminal: it calls `sudo`, prompts for the commit message with `read`, and pushes. Run via Claude or the `!` prefix, sudo fails, nothing syncs, and git reports "nothing to commit". Deploying a single changed dotfile with `cp` is safer than `copy-config.sh` when other home copies may have diverged; `diff` first.
- TearFree is forced on in `configuration.nix`. The driver default `auto` only enables it on scaled/rotated outputs, so the unscaled beamer tore in VLC (no compositor under i3).
- NVIDIA completely blacklisted for battery life; AMD iGPU only
- `environment.variables.DUMMY_FORCE_REBUILD = "true"` exists solely to force a rebuild when needed; safe to change value
- SonicWall DNS workaround: `/etc/resolv.conf` and both `systemd-resolved` paths are symlinked to a user-writable file at `/home/chai/.sonicwall/AventailConnect/tmp/resolv.conf`
- `system.stateVersion = "24.05"` — do not change

## TODO
