{ stdenv, lib, fetchurl, unzip, glib, systemd, nss, nspr, gtk3-x11, pango,
atk, cairo, gdk-pixbuf, xorg, xorg_sys_opengl, util-linux, alsa-lib, dbus, at-spi2-atk,
cups, vivaldi-ffmpeg-codecs, libpulseaudio, at-spi2-core, libxkbcommon, mesa }:

stdenv.mkDerivation rec {
  pname = "exodus";
  # version = "v21.8.27";

  version = "v21.8.27";
    src = fetchurl {
      # url = "https://downloads.exodus.io/releases/exodus-linux-x64-20.8.28.zip";
      url = "https://downloads.exodus.io/releases/exodus-linux-x64-21.8.27.zip";
      sha256 = "0xdv2wxiy5ryx9ssq1vry7fw3vbslmwc9my2nd6j7i66qrnyksln";
      # sha256 = "1vv53l2f8kcjix62ngrqb84yh06j4vnf7p1di7v43mphf5gidsgx";
    };


  # src = fetchurl {
  #   url = "https://downloads.exodus.io/releases/${pname}-linux-x64-${version}.zip";
  #   sha256 = "1ssacadx5hdxq0cljb869ds3d11i4fyy3qd5hzh8wk5mlpdnba6k";
  # };

  sourceRoot = ".";
  unpackCmd = ''
      ${unzip}/bin/unzip "$src" -x "Exodus*/lib*so"
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/applications
    cd Exodus-linux-x64
    cp -r . $out
    ln -s $out/Exodus $out/bin/Exodus
    ln -s $out/bin/Exodus $out/bin/exodus
    ln -s $out/exodus.desktop $out/share/applications
    substituteInPlace $out/share/applications/exodus.desktop \
          --replace 'Exec=bash -c "cd `dirname %k` && ./Exodus"' "Exec=Exodus"
  '';

  dontPatchELF = true;
  dontBuild = true;

  preFixup = let
    libPath = lib.makeLibraryPath [
      glib
      nss
      nspr
      gtk3-x11
      pango
      atk
      cairo
      gdk-pixbuf
      xorg.libX11
      xorg.libxcb
      xorg.libXcomposite
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXi
      xorg.libXrender
      xorg.libxshmfence
      xorg.libXtst
      xorg_sys_opengl
      util-linux
      xorg.libXrandr
      xorg.libXScrnSaver
      alsa-lib
      dbus.lib
      at-spi2-atk
      at-spi2-core
      cups.lib
      libpulseaudio
      systemd
      vivaldi-ffmpeg-codecs
      libxkbcommon
      mesa
    ];
  in ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}" \
      $out/Exodus
  '';

  meta = with lib; {
    homepage = "https://www.exodus.io/";
    description = "Top-rated cryptocurrency wallet with Trezor integration and built-in Exchange";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mmahut rople380 ];
  };
}
