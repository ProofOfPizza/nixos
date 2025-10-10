
{
  description = "My NixOS configuration with KeeWeb + SonicWall Connect Tunnel";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }: let
    system = "x86_64-linux";
    pkgs   = import nixpkgs { inherit system; };

    # KeeWeb build info
    pname   = "keeweb";
    version = "1.18.7";
    src     = pkgs.fetchurl {
      url    = "https://github.com/keeweb/keeweb/releases/download/v${version}/KeeWeb-${version}.linux.AppImage";
      sha256 = "0000000000000000000000000000000000000000000000000000";  # ⇽ fill in with nix-prefetch later
    };
  in {
    # ─── NixOS host configuration ───────────────────────────────────────────
    nixosConfigurations.my-nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix

        # SonicWall Connect-Tunnel system module
        ./module.nix
      ];
    };

    # ─── Extra packages built by this flake (KeeWeb) ────────────────────────
    packages.${system}.keeweb = pkgs.stdenv.mkDerivation {
      inherit pname version src;
      nativeBuildInputs = [ pkgs.appimageTools pkgs.libsecret ];

      installPhase = ''
        appimageTools.extractAppImage "$src" "$out"
        chmod +x  $out/bin/KeeWeb
        mv        $out/bin/KeeWeb $out/bin/keeweb
        install -Dm644 $out/KeeWeb.desktop -t $out/share/applications
        install -Dm644 $out/KeeWeb.png     -t $out/share/icons/hicolor/256x256/apps
      '';
    };
  };
}
