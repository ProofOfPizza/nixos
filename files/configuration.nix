# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  # Import the Alacritty configuration
  alacrittyConfig = import ./programs/terminal/alacritty/default-settings.nix;
in

{
  imports =
    [ # Include the results of the hardware scan.
    # other imports...
    ./hardware-configuration.nix
    ];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-d60000a7-b82b-4115-ba74-6393eb27a095".device = "/dev/disk/by-uuid/d60000a7-b82b-4115-ba74-6393eb27a095";
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  environment.etc."alacritty/alacritty.yml".text = builtins.toJSON alacrittyConfig;
  environment.variables = {
    EDITROR= "nvim";
    BROWSER= "chromium";
    TERMINAL= "alacritty";
    };


  environment.etc."sudoers".text = ''
    Defaults env_keep += "HOME"
    Defaults env_keep += "SSH_AUTH_SOCK"
  '';

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  # Configure keymap in X11
  services = {
    libinput.enable = true;
    displayManager = {
      defaultSession = "none+i3";
    };
    gnome.gnome-keyring = {
      enable = true;
    };
    xserver = {
      enable = true;
      xkb.layout = "us";
      xkb.variant = "";
      xkb.options = "caps:swapescape";
      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
        extraPackages = with pkgs; [
          dmenu
          i3status
          i3lock
          i3blocks
        ];
	extraSessionCommands = ''
	  eval $(gnome-keyring-daemon --daemonize)
	  export SSH_AUTH_SOCK
	'';
      };
    };
  };
  virtualisation.docker.enable = true;

  services.lorri.enable = true;
# Oh My Zsh setup
  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      theme = "agnoster";  # Set your preferred theme
      plugins = [ "git" "docker" ];  # List of plugins
    };
  };


programs.neovim = {
  enable = true;
  configure = {
    packages.myVimPackage = with pkgs.vimPlugins; {
      start = [
        vim-sensible
        coc-nvim
        argtextobj-vim
        auto-pairs
        direnv-vim
        fzf-vim
        haskell-vim
        i3config-vim
        papercolor-theme
        vim-commentary
        vim-css-color
        vim-floaterm
        vim-javascript
        vim-jsx-pretty
        tabular
        csv-vim
        syntastic
        gruvbox
        vim-airline
        vim-airline-themes
        vim-polyglot
        vim-surround
        vim-go
      ];
    };
    customRC = ''
      source /etc/nixos/programs/editor/neovim/init.vim
      '';
  };
};
# Configure Zsh as the default shell
  users.defaultUserShell = pkgs.zsh;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.chai = {
    isNormalUser = true;
    description = "chai";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    alacritty
    arandr
    bluez
    bluez-tools
    brave
    chromium
    direnv
    docker
    docker-compose
    element-desktop
    evince
    firefox
    flameshot
    fzf
    git
    gnome.gnome-keyring
    gnupg
    htop
    jq
    keepass
    keeweb
    libreoffice
    lorri
    mcomix3
    nextcloud-client
    nmap
    nodejs_22
    oh-my-zsh
    pavucontrol
    p7zip
    peek
    poppler_utils
    postman
    pulseaudio
    pulsemixer
    ripgrep
    signal-desktop
    slack
    spotify
    steam
    stellarium
    sublime3
    transmission_4-gtk
    ueberzug
    udiskie
    unrar
    unzip
    viewnior
    vifm
    vlc
    vscodium
    wireguard-tools
    xarchiver
    xclip
    xmrig
    xournalpp
    zathura
    zoom-us
    zsh
    zsh-autosuggestions
  ];

  hardware.bluetooth.enable = true;

  services.blueman = {
    enable = true; # Optional, provides a GUI for managing Bluetooth
  };
  hardware.pulseaudio.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}