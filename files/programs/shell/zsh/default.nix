{ config, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    autocd = true;
    defaultKeymap = "viins";

    # Shell aliases
    shellAliases = import ./aliases.nix;

    # Oh My Zsh setup
    oh-my-zsh = import ./oh-my-zsh.nix;

    extraConfig = import ./extra-config.nix;
  };
}
