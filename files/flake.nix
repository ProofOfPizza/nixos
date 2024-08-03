{
  description = "My NixOS Configuration with KeeWeb and other packages";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/63dacb46bf939521bdc93981b4cbb7ecb58427a0";


  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      pname = "keeweb";
      version = "1.18.7";
      src = pkgs.fetchurl {
        url = "https://github.com/keeweb/keeweb/releases/download/v${version}/KeeWeb-${version}.linux.AppImage";
        sha256 = "0000000000000000000000000000000000000000000000000000";
      };
    in
    {
      nixosConfigurations = {
        my-nixos = nixpkgs.lib.nixosSystem {
          system = system;
          modules = [
            ./configuration.nix
          ];
        };
      };

      packages = {
        ${system} = {
          keeweb = pkgs.stdenv.mkDerivation {
            pname = pname;
            inherit version src;
            nativeBuildInputs = [ pkgs.appimageTools pkgs.libsecret ];

            installPhase = ''
              appimageTools.extractAppImage "$src" "$out"
              chmod +x $out/bin/KeeWeb
              mv $out/bin/KeeWeb $out/bin/keeweb
              install -Dm644 $out/KeeWeb.desktop -t $out/share/applications
              install -Dm644 $out/KeeWeb.png -t $out/share/icons/hicolor/256x256/apps
            '';
          };
        };
      };
    };
}









# {
#   description = "My NixOS Configuration with Vim etc and Flakes";

#   inputs = {
#     nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
#   };

#   outputs = { self, nixpkgs, ... }:
#     let
#       system = "x86_64-linux";
#     in
#     {
#       nixosConfigurations = {
#         my-nixos = nixpkgs.lib.nixosSystem {
#           system = system;
#           modules = [

#             ./configuration.nix ];
#         };
#       };

#       packages.${system} = {
#         vimConfig = import ./vim/default.nix;
#       };
#     };
# }
