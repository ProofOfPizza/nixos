# programs/terminal/alacritty/default-settings.nix

{
  window = {
    opacity = 0.75;
    padding = { x = 10; y = 10; };
    decorations = "full";
  };

  font = {
    size = 11.0;
    normal = { family = "Inconsolata-g for Powerline"; };
    bold = { family = "Inconsolata-g for Powerline"; };
    italic = { family = "Inconsolata-g for Powerline"; };
  };

  cursor = { style = "Beam"; };

  shell = { program = "zsh"; };

  colors = {
    primary = {
      background = "0x2E3440";
      foreground = "0xD8DEE9";
    };
    normal = {
      black   = "0x3B4252";
      red     = "0xBF616A";
      green   = "0xA3BE8C";
      yellow  = "0xEBCB8B";
      blue    = "0x81A1C1";
      magenta = "0xB48EAD";
      cyan    = "0x88C0D0";
      white   = "0xE5E9F0";
    };
    bright = {
      black   = "0x4C566A";
      red     = "0xBF616A";
      green   = "0xA3BE8C";
      yellow  = "0xEBCB8B";
      blue    = "0x81A1C1";
      magenta = "0xB48EAD";
      cyan    = "0x8FBCBB";
      white   = "0xECEFF4";
    };
  };
}

