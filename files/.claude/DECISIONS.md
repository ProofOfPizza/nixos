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
