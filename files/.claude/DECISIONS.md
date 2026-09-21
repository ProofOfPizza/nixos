# Decisions

## 2024-xx-xx: NixOS flake over channels
Using flakes (`nixos-unstable`) for reproducibility and to use `nix flake` commands. `nix-command` and `flakes` experimental features enabled in `nix.extraOptions`.

## 2024-xx-xx: SonicWall Connect Tunnel as custom derivation
SonicWall is not in nixpkgs (unfree binary, proprietary). Built as a local `callPackage` derivation in `connect-tunnel.nix` with patched ELF interpreter and capability wrappers instead of SUID.

## 2024-xx-xx: NVIDIA disabled for battery life
Laptop has AMD iGPU + NVIDIA dGPU. NVIDIA removed via udev PCI removal rules + kernel module blacklist. AMD only. Saves significant battery without needing `switcheroo` or PRIME hybrid.

## 2024-xx-xx: PulseAudio over Pipewire
Pipewire explicitly disabled (`services.pipewire.enable = false`). PulseAudio used with `pulseaudioFull` for Bluetooth codec support. Likely a stability/familiarity choice.

## 2024-xx-xx: Caps Lock → Escape swap
`xkb.options = "caps:swapescape"` — Caps and Escape swapped system-wide in X11. Neovim-friendly.

## 2024-xx-xx: DNS symlink workaround for SonicWall
Rather than patching the binary, all three resolv.conf paths are symlinked to a user-writable file. Enforcement layered across tmpfiles + activationScripts + a oneshot systemd service to survive resolved restarts.

## 2026-09-21: Keep KeeWeb as a local derivation instead of migrating to KeePassXC
nixpkgs dropped `keeweb` (EOL Electron). Upstream has been unmaintained since 1.18.7 in July 2021, so this will not be reverted.

Kept it anyway, built locally from `programs/custom-built/keeweb/keeweb.nix` at the same 1.18.7 — no downgrade from what was running. KeePassXC was the obvious replacement and was rejected on two counts, both central to daily use:

1. **Sync.** KeeWeb talks WebDAV to Nextcloud directly. There is no local sync folder and the Nextcloud desktop client is not running, so KeePassXC (local files only) would have required introducing filesystem-level sync first — an architecture change, not a swap.
2. **Global hotkeys.** shift-alt-b/c copy username/password while backgrounded, without leaving the current app or workspace. KeePassXC exposes exactly one global shortcut (Auto-Type); the separate type-username/type-password actions cannot be bound globally.

Accepted cost: the FHS lib set is now our problem and will break on nixpkgs bumps (see Gotchas). Revisit if a maintained password manager gains both native WebDAV and global copy hotkeys.

## 2026-09-21: Packages dropped on the 2026-09 nixpkgs bump
- `qbz` — removed upstream at the maintainer's request, source no longer available. Do not try to re-add it. Qobuz replaced by `strawberry`, which has unofficial Qobuz streaming; credentials are scraped with `qobuz-creds.py` (see Gotchas). Verified working 2026-09-21.
- `claude-code` `overrideAttrs` pin (2.1.220, hardcoded sha256) — deleted. nixpkgs shipped 2.1.276, ahead of the pin, so the override was only holding it back. Use the nixpkgs package directly; only re-pin if nixpkgs falls behind.
