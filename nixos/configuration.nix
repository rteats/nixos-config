# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      
      packageOverrides = pkgs: {
        intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  };

    };
  };

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libvdpau-va-gl
    ];
  };
  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; }; # Force intel-media-driver


  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # FIXME: Add the rest of your current configuration

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    # FIXME: Replace with your username
    user = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      initialPassword = "user";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = ["wheel" "networkmanager" "audio"];
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "teclast";
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

#  i18n.extraLocaleSettings = {
#    LANGUAGE = "en_US.UTF-8";
#    LC_ALL = "en_US.UTF-8";
#    LC_ADDRESS = "en_US.UTF-8";
#    LC_IDENTIFICATION = "en_US.UTF-8";
#    LC_MEASUREMENT = "en_US.UTF-8";
#    LC_MONETARY = "en_US.UTF-8";
#    LC_NAME = "en_US.UTF-8";
#    LC_NUMERIC = "en_US.UTF-8";
#    LC_PAPER = "en_US.UTF-8";
#    LC_TELEPHONE = "en_US.UTF-8";
#    LC_TIME = "en_US.UTF-8";
#  };

  security.doas = {
    enable = true;
    extraRules = [ { users = ["user"]; persist = true; } ];
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the XFCE Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.desktopManager.xfce.noDesktop = true;
  services.picom.enable = true;

  #services.xserver.windowManager.awesome.enable = true;
  services.xserver.windowManager.spectrwm.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us,ru";
    xkbVariant = ",winkeys";
    xkbOptions = "grp:toggle,caps:escape";
  };

  # Enable sound with pipewire.
#  sound.enable = true;
  #hardware.pulseaudio.enable = true;
#  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.fractalart.enable = true;

  services.logind.extraConfig = "HandlePowerKey=ignore";

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.blueman.enable = true;

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      # Opinionated: forbid root login through SSH.
      PermitRootLogin = "no";
      # Opinionated: use keys only.
      # Remove if you want to SSH using passwords
      PasswordAuthentication = false;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    xclip
    zsh
    ffmpeg

    # editors
    neovim 

    wget
    cmake
    xcape
    wine
    wine64
    winetricks

    gnumake
    harfbuzz

    python3Full
    pyright
    #tsserver
    doas
    xfce.xfce4-volumed-pulse
    xfce.xfce4-pulseaudio-plugin
    xfce.xfce4-whiskermenu-plugin
    #xfce.xfdesktop
    stylua
    black
    gcc
    git
    home-manager
    openssh
    fzf
    ripgrep
    xclip
    # dxvk vkd3d-proton dxvk-nvapi latencyflex runtime winebridge soda
  ];

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      inter
      jetbrains-mono
      intel-one-mono
    ];
    fontconfig = {
      defaultFonts = {
        #serif = [ "Vazirmatn" "Ubuntu" ];
        sansSerif = [ "Inter" ];
        monospace = [ "JetBrains Mono" ];
      };
    };
  };

  #services.xserver.windowManager.dwm.enable = true;
  #services.xserver.windowManager.dwm.package = pkgs.dwm.overrideAttrs {
  #  src = pkgs.fetchFromGitHub {
  #    owner = "rteats";
  #    repo = "dwm";
  #    rev = "latest";
  #    sha256 = lib.fakeSha256;
  #    #sha256 = "0/YOL1/G2SWncbLNaclSYUz7VyfWu+OB8TYJYm4NYkM=";
  #      #sha256 = "xbchXJTFWeABTwq6h4KWLh+EvydDrDzcY9AQVK65RS8=";
  #  };
  #};

  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
