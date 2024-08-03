
#{ pkgs ? import (fetchTarball https://github.com/nixos/nixpkgs/archive/nixpkgs-unstable.tar.gz) {} }:
with import <nixpkgs> {};

let
  customPython = pkgs.python38.buildEnv.override {
    extraLibs = [ pkgs.python38Packages.ipython pkgs.python38Packages.i3-py ];
  };
in

pkgs.mkShell {
  buildInputs = [ customPython ];
}

