
{ lib, pkgs, config, ... }:

let
  cfg    = config.programs.connect-tunnel;
  ctPkg  = pkgs.callPackage ./connect-tunnel.nix { };
in {
  options.programs.connect-tunnel.enable =
    lib.mkEnableOption "SonicWall SMA Connect Tunnel VPN client";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ ctPkg ];

    # keep binary name stable
    environment.etc."profile.d/99-connect-tunnel.sh".text = ''
      export PATH=${ctPkg}/bin:$PATH
    '';

    # capabilities so AvConnect can create tun + routes
    security.wrappers."AvConnect" = {
      owner  = "root";
      group  = "root";
      setuid = true;
      source = "${ctPkg}/usr/local/Aventail/AvConnect";
    };

    # ensure /dev/net/tun exists early on
    boot.extraModprobeConfig = "options tun";


    systemd.tmpfiles.rules = [
      # ---------- /bin ----------
      "L /bin/bash      - - - - /run/current-system/sw/bin/bash"
      "L /bin/killall   - - - - /run/current-system/sw/bin/killall"

      # ---------- /sbin ----------
      "L /sbin/ip       - - - - /run/current-system/sw/bin/ip"
      "L /sbin/route    - - - - /run/current-system/sw/bin/route"
      "L /sbin/iptables - - - - /run/current-system/sw/bin/iptables"

      # ---------- Aventail ----------
      "d /usr/local/Aventail               0755 root root - -"
      "L /usr/local/Aventail/AvConnect - - - - /run/wrappers/bin/AvConnect"
    ];
    ## -----------------------------------------

    system.activationScripts.connectTunnelBash.text = ''
      ln -sf /run/current-system/sw/bin/bash /bin/bash
    '';

  };
}
