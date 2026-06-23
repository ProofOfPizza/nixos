# Architecture & Design

## Structure
Single-host NixOS flake. One `nixosConfigurations.my-nixos` entry composed from:
1. `hardware-configuration.nix` — generated, do not hand-edit
2. `configuration.nix` — all system-level options
3. `module.nix` — custom NixOS module (SonicWall Connect Tunnel)

Custom packages live in `connect-tunnel.nix` (and eventually KeeWeb in `flake.nix`), called via `pkgs.callPackage`.

## Module pattern
`module.nix` follows the standard NixOS module pattern:
- `options.programs.connect-tunnel.enable` — opt-in toggle
- `config = lib.mkIf cfg.enable { ... }` — all wiring behind the toggle
- Enabled unconditionally in `configuration.nix` imports

## DNS workaround rationale
SonicWall's `AvConnect` binary tries to modify `/etc/resolv.conf` and systemd-resolved's stub files directly, which fails on NixOS (read-only store paths and protected systemd paths). The workaround creates a single writable file at `~/.sonicwall/.../resolv.conf` and symlinks all three paths to it. Both `tmpfiles` rules and `activationScripts` + a oneshot systemd service enforce this because tmpfiles alone doesn't survive a `systemd-resolved` restart.

## Capability model
`AvConnect` binary needs `cap_net_admin`, `cap_net_raw`, `cap_dac_override` to create tun interfaces and modify routes. These are granted via `security.wrappers` rather than SUID to stay compatible with NixOS security model.

## Battery saving
NVIDIA dGPU removed from PCI at runtime via udev rules + kernel module blacklisting. Only AMD iGPU active. This is intentional and permanent.

## Audio
PulseAudio with `pulseaudioFull` (for Bluetooth codecs). Pipewire explicitly disabled. Bluetooth managed via blueman + bluez.
