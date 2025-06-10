
{ lib
, stdenv
, fetchurl
, unzip
, zip
, zulu17  # JDK 17 runtime
, psmisc  # killall
, iproute2
, iptables
, nettools
, makeWrapper
}:

let
  pname         = "sonicwall";
  version       = "12.43.00298";
  shortVersion  = "12.4.3";

  meta = with lib; {
    description         = "SonicWall SMA Connect Tunnel VPN client";
    homepage            = "https://www.sonicwall.com";
    sourceProvenance    = with sourceTypes; [ binaryNativeCode ];
    license             = licenses.unfree;
    platforms           = [ "x86_64-linux" ];
  };

in stdenv.mkDerivation {
  inherit pname version meta;

  src = fetchurl {
    url    = "https://software.sonicwall.com/CT-NX-VPNClients/CT-${shortVersion}/ConnectTunnel_Linux64-${version}.tar";
    # fill in with `nix-prefetch-url` once
    # sha256 = "0000000000000000000000000000000000000000000000000000";
    sha256 = "19w3pzdvn7r7wvm26xnsg4p9p5gv3ig0qjzjqimckz4qy1cgh5p4";
  };

  buildInputs = [
    unzip
    psmisc
    iproute2
    iptables
    nettools
  ];
  nativeBuildInputs = [ makeWrapper ];

  unpackPhase = ''tar -xf $src'';

  installPhase = ''
    # extract inner payload
    tar -xf ConnectTunnel*.tar.bz2
    cd usr/local/Aventail || cd ConnectTunnel_Linux64-*/usr/local/Aventail

    # copy UI jar to expected place
    install -Dm644 ui/SnwlConnect.jar $out/usr/local/Aventail/ui/SnwlConnect.jar

    # certificates expected by AvConnect
    mkdir -p $out/usr/local/Aventail/library/certificates
    tar -xjf certs.tar.bz2 -C  $out/usr/local/Aventail/library/certificates

    # scripts & binary
    install -Dm755 startct.sh      $out/usr/local/Aventail/startct.sh
    install -Dm755 startctui.sh    $out/usr/local/Aventail/startctui.sh
    install -Dm755 AvConnect       $out/usr/local/Aventail/AvConnect

    # prepend JAVA_HOME & skip kernel module
    for f in $out/usr/local/Aventail/startct*.sh; do
      sed -i '1 i\export JAVA_HOME=${zulu17}\nexport PATH=${zulu17}/bin:$PATH\nexport XG_SKIP_MODULE=1' "$f"
    done

    sed -i "s|^xg_inst_dir=.*|xg_inst_dir=$out/usr/local/Aventail/ui|" \
           $out/usr/local/Aventail/startctui.sh

    # helper tools expected in /bin & /sbin
    mkdir -p $out/bin $out/sbin
    ln -s ${psmisc}/bin/killall   $out/bin/killall
    ln -s ${iproute2}/bin/ip      $out/sbin/ip
    ln -s ${iptables}/bin/iptables $out/sbin/iptables
    ln -s ${nettools}/bin/route   $out/sbin/route

    # thin wrapper
    makeWrapper $out/usr/local/Aventail/startctui.sh \
                $out/bin/connect-tunnel \
                --set LD_LIBRARY_PATH "${zulu17}/lib"
  '';

  postFixup = let
    libPath = lib.makeLibraryPath [ stdenv.cc.cc.lib ];
  in ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
             --set-rpath "${libPath}" \
             $out/usr/local/Aventail/AvConnect

    # give capabilities instead of SUID
    chmod u-s $out/usr/local/Aventail/AvConnect
  '';

  # expose to other derivations
  # meta = meta // { mainProgram = "connect-tunnel"; };
}