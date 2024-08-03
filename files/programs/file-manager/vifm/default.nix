# In programs/file-manager/vifm/default.nix
{ pkgs, lib, ... }:

{
  home.file = {
    ".vifm/vifmrc".source = ./vifmrc;
    ".vifm/scripts/vifmrun".source = ./scripts/vifmrun;
    ".vifm/scripts/vifmimg".source = ./scripts/vifmimg;
    ".vifm/colors/zenburn_1.vifm".source = ./colors/zenburn_1.vifm;
    # get the colors from git: git clone https://github.com/vifm/vifm-colors ~/.config/vifm/colors
  };
}
