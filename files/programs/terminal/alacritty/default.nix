
{ config, lib, pkgs, ... }:

let
  customSettings = import ./default-settings.nix;
in
{
  programs.alacritty = {
    enable = true;
    settings = lib.attrsets.recursiveUpdate customSettings {
      # You can override or add additional settings here if necessary
    };
  };
}
