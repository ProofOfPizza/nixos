{ lib, stdenv, fetchurl, appimageTools, undmg, libsecret }:
let
# copy from https://github.com/sikmir/nixpkgs/blob/master/pkgs/applications/misc/keeweb/default.nix
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  pname = "keeweb";
  version = "1.16.7";
  name = "${pname}-${version}";

  suffix = {
    x86_64-linux = "linux.AppImage";
    x86_64-darwin = "mac.x64.dmg";
    aarch64-darwin = "mac.arm64.dmg";
  }.${system} or throwSystem;

  src = fetchurl {
    url = "https://github.com/keeweb/keeweb/releases/download/v${version}/KeeWeb-${version}.${suffix}";
    sha256 = {
      x86_64-linux = "0a4yh2jh9sph17mqqi62gm5jc4yffkysq6yiggyzz5f8xw4p315j";
      x86_64-darwin = "0crpjkcqgs7q5c814bx2npjh9kpyyb87yagm5wcy9j21kwrbqv6k";
      aarch64-darwin = "1wkf9inrm5qg0c4xrk0s97mx5j21xvlqwwkvydl513gyfzi2g9gp";
    }.${system} or throwSystem;
  };

  appimageContents = appimageTools.extract {
    inherit name src;
  };

  meta = with lib; {
    description = "Free cross-platform password manager compatible with KeePass";
    homepage = "https://keeweb.info/";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };

  linux = appimageTools.wrapType2 rec {
    inherit name src meta;
    extraPkgs = pkgs: with pkgs; [ libsecret ];
    extraInstallCommands = ''
      mv $out/bin/{${name},${pname}}
      install -Dm644 ${appimageContents}/keeweb.desktop -t $out/share/applications
      install -Dm644 ${appimageContents}/keeweb.png -t $out/share/icons/hicolor/256x256/apps
      install -Dm644 ${appimageContents}/usr/share/mime/keeweb.xml -t $out/share/mime
      substituteInPlace $out/share/applications/keeweb.desktop \
        --replace 'Exec=AppRun' 'Exec=${pname}'
    '';
  };

#  propagatedBuildInputs = pkgs: with pkgs; [ libsecret gnome3.libgnome-keyring ];
  darwin = stdenv.mkDerivation {
    inherit pname version src meta;

    nativeBuildInputs = [ undmg ];

    sourceRoot = "KeeWeb.app";

    installPhase = ''
      mkdir -p $out/Applications/KeeWeb.app
      cp -R . $out/Applications/KeeWeb.app
    '';
  };
in
if stdenv.isDarwin
then darwin
else linux

