
{ lib, pkgs, config, ... }:

let
  cfg    = config.programs.connect-tunnel;
  ctPkg  = pkgs.callPackage ./connect-tunnel.nix { };
in {
  options.programs.connect-tunnel.enable =
    lib.mkEnableOption "SonicWall SMA Connect Tunnel VPN client";

  config = lib.mkIf cfg.enable {
    ##################################################
    # ---------- Packages and paths ----------
    ##################################################
    environment.systemPackages = [ ctPkg ];

    # Capabilities so AvConnect can create tun + routes
    security.wrappers."AvConnect" = {
      owner = "root";
      group = "root";
      capabilities = "cap_net_admin,cap_net_raw,cap_dac_override+ep";
      source = "${ctPkg}/usr/local/Aventail/AvConnect";
    };

    # Ensure /dev/net/tun exists early on
    boot.kernelModules = [ "tun" ];

    # Disable systemd-resolved managing the stub file
    services.resolved = {
      enable = true;
      extraConfig = ''
        DNSStubListener=no
      '';
    };

    ##################################################
    # ---------- tmpfiles setup ----------
    ##################################################
    systemd.tmpfiles.rules = [
      ##################################################
      # ---------- /bin symlinks ----------
      ##################################################
      "L /bin/bash      - - - - /run/current-system/sw/bin/bash"
      "L /bin/killall   - - - - /run/current-system/sw/bin/killall"

      ##################################################
      # ---------- /sbin symlinks ----------
      ##################################################
      "L /sbin/ip       - - - - /run/current-system/sw/bin/ip"
      "L /sbin/route    - - - - /run/current-system/sw/bin/route"
      "L /sbin/iptables - - - - /run/current-system/sw/bin/iptables"

      ##################################################
      # ---------- Aventail / SonicWall ----------
      ##################################################
      # Ensure base directory exists and wrapper points correctly
      "d /usr/local/Aventail               0755 root root - -"
      "L /usr/local/Aventail/AvConnect - - - - /run/wrappers/bin/AvConnect"

      ##################################################
      # ---------- Writable DNS setup ----------
      ##################################################
      # Create writable temporary folder for the VPN client
      "d /home/chai/.sonicwall/AventailConnect/tmp 0755 chai users - -"

      # Create a writable fake resolv.conf that SonicWall can safely modify
      "f /home/chai/.sonicwall/AventailConnect/tmp/resolv.conf 0666 root users - -"

      # Replace the systemd stub resolv.conf with a writable symlink target
      # This avoids permission errors while keeping systemd-resolved happy
      "L /run/systemd/resolve/stub-resolv.conf - - - - /home/chai/.sonicwall/AventailConnect/tmp/resolv.conf"

      # Also point /etc/resolv.conf to the same file for consistency
      "L /etc/resolv.conf - - - - /home/chai/.sonicwall/AventailConnect/tmp/resolv.conf"

      "L /run/systemd/resolve/resolv.conf - - - - /home/chai/.sonicwall/AventailConnect/tmp/resolv.conf"
      "L /etc/resolv.conf - - - - /home/chai/.sonicwall/AventailConnect/tmp/resolv.conf"

    ];

    ##################################################
    # ---------- Activation fix ----------
    ##################################################
    system.activationScripts.connectTunnelBash.text = ''
      ln -sf /run/current-system/sw/bin/bash /bin/bash
    '';
    system.activationScripts.fixResolvSymlink.text = ''
      rm -f /run/systemd/resolve/resolv.conf
      ln -sf /home/chai/.sonicwall/AventailConnect/tmp/resolv.conf /run/systemd/resolve/resolv.conf
    '';
    ##################################################
    # ---------- Environment setup ----------
    ##################################################
    # Keep binary name stable and make AvConnect discoverable in PATH
    environment.etc."profile.d/99-connect-tunnel.sh".text = ''
      export PATH=${ctPkg}/bin:$PATH
    '';

    systemd.services.fix-resolv-symlink = {
      description = "Ensure writable resolv.conf for Connect Tunnel";
      after = [ "systemd-resolved.service" ];
      wants = [ "systemd-resolved.service" ];
      wantedBy = [ "systemd-resolved.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "/run/current-system/sw/bin/bash -c 'for f in /run/systemd/resolve/resolv.conf /run/systemd/resolve/stub-resolv.conf; do rm -f \"$f\"; ln -sf /home/chai/.sonicwall/AventailConnect/tmp/resolv.conf \"$f\"; done'";
      };
    };
  };
}
