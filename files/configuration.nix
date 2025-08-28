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
    ./module.nix
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

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # extra hosts voor solcon werk
  # extra localhost for h2b traefik
  networking.extraHosts = ''
    139.156.121.234 teamkpn.kpnnet.org
    139.156.121.234 ksp.kpnnet.org
    139.156.121.170 cordys.reggefiber.net
    139.156.122.196 apps.reggefiber.net
    139.156.121.83 ipos.kpn.org
    139.156.120.2 jira.kpn.org
    139.156.120.3 jira-acc.kpn.org
    139.156.120.4 confluence.kpn.org
    139.156.78.81 confluence-acc.kpn.org
    195.121.13.98 blip-acc.tcloud-itv-acc1.np.aws.kpn.org
    195.121.13.97 blip.tcloud-itv-prd1.prod.aws.kpn.org
    127.0.0.1 app.localhost
    127.0.0.1 traefik.localhost
  '';


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
  services.redshift = {
    enable = true;
    brightness.night = "0.8";
    temperature.night = 3300;
  };

  location.latitude = 51.2518202;
  location.longitude = 4.023880;

  #enable automount
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  programs.connect-tunnel.enable = true;

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
        YouCompleteMe
        argtextobj-vim
        auto-pairs
        coc-nvim
        csv-vim
        direnv-vim
        fzf-vim
        gruvbox
        haskell-vim
        i3config-vim
        papercolor-theme
        syntastic
        tabular
        vim-airline
        vim-airline-themes
        vim-commentary
        vim-css-color
        vim-floaterm
        vim-go
        vim-javascript
        vim-jsx-pretty
        vim-polyglot
        vim-sensible
        vim-surround
      ];
    };
    customRC = ''
      source /etc/nixos/programs/editor/neovim/init.vim
      '';
  };
};

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    glibc
    openssl
    libffi
    libxml2
    libxslt
    xz
    bzip2
    ncurses
  ];
# Configure Zsh as the default shell
  users.defaultUserShell = pkgs.zsh;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.chai = {
    isNormalUser = true;
    description = "chai";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "docker" "beep" ];
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
    calibre
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
    openvpn
    pavucontrol
    pciutils
    p7zip
    peek
    poppler_utils
    postman
    pulseaudio
    pulsemixer
    python3
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
    zip
    unzip
    zoom-us
    zsh
    zsh-autosuggestions
  ];

  environment.variables.DUMMY_FORCE_REBUILD = "true";
  hardware.bluetooth.enable = true;

  services.blueman = {
    enable = true; # Optional, provides a GUI for managing Bluetooth
  };
  hardware.pulseaudio.enable = true;




# This runs only intel/amdgpu igpus and nvidia dgpus do not drain power.
# this part is to save batt life. found here: https://github.com/NixOS/nixos-hardware/blob/59e37017b9ed31dee303dbbd4531c594df95cfbc/common/gpu/nvidia/disable.nix and mentioned https://discourse.nixos.org/t/battery-life-still-isnt-great/41188

  ##### disable nvidia, very nice battery life.
  boot.extraModprobeConfig = ''
    blacklist nouveau
    options nouveau modeset=0
  '';

  services.udev.extraRules = ''
    # Remove NVIDIA USB xHCI Host Controller devices, if present
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"

    # Remove NVIDIA USB Type-C UCSI devices, if present
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"

    # Remove NVIDIA Audio devices, if present
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"

    # Remove NVIDIA VGA/3D controller devices
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
  '';
  boot.blacklistedKernelModules = [ "nouveau" "nvidia" "nvidia_drm" "nvidia_modeset" ];
  ## End batt saving stuff

# Use systemd-resolved with public DNS so CT avoids flaky modem DNS
services.resolved = {
  enable = true;
  fallbackDns = [ "1.1.1.1" "8.8.8.8" ];
  dnssec = "allow-downgrade";
};

######################################################
# Stuff done to get sonicwall to work
######################################################


# Make NetworkManager talk to systemd-resolved's stub resolver
networking.networkmanager.dns = "systemd-resolved";

# (Optional but harmless) Also declare nameservers explicitly
networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

# Pin the VPN host to IPv4 so CT never needs to resolve it
# (you confirmed 212.45.53.68 and both FQDNs appear in logs/cert)
networking.hosts."212.45.53.68" = [ "vpn.solcon.nl" "vpn01.solcon.nl" ];

#######################################################

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
