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
    # inputs.nixos-hardware.nixosModules.common-cpu-amd
    # inputs.nixos-hardware.nixosModules.common-pc-ssd
    # inputs.nixos-hardware.nixosModules.common-hidpi

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

      #nvim-nix.overlays.default
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

      # packageOverrides = pkgs: {
      #   intel-vaapi-driver = pkgs.intel-vaapi-driver.override {enableHybridCodec = true;};
      # };
    };
  };

  # hardware.opengl = {
  #   enable = true;
  #   extraPackages = with pkgs; [
  #     intel-media-driver # LIBVA_DRIVER_NAME=iHD
  #     intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
  #     libvdpau-va-gl
  #   ];
  # };
  # environment.sessionVariables = {LIBVA_DRIVER_NAME = "iHD";}; # Force intel-media-driver

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
      extraGroups = [ "video" "wheel" "networkmanager" "audio" "users"];
    };
  };

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.grub.copyKernels = false;
  boot.loader.grub.useOSProber = true;
  #boot.loader.grub.storePath = false;



  boot.supportedFilesystems = ["ntfs"];

  boot.kernelModules = [ "tun" ];

  services.fprintd.enable = true;
 # If simply enabling fprintd is not enough, try enabling fprintd.tod...
  services.fprintd.tod.enable = true;
  # ...and use one of the next four drivers
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix; # Goodix driver module
  # services.fprintd.tod.driver = pkgs.libfprint-2-tod1-elan; # Elan(04f3:0c4b) driver
  # services.fprintd.tod.driver = pkgs.libfprint-2-tod1-vfs0090; # (Marked as broken as of 2025/04/23!) driver for 2016 ThinkPads
  # services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix-550a; # Goodix 550a driver (from Lenovo)

  # however for focaltech 2808:a658, use fprintd with overidden package (without tod)
  # services.fprintd.package = pkgs.fprintd.override {
  #   libfprint = pkgs.libfprint-focaltech-2808-a658;
  # };

  # boot.resumeDevice = "/dev/disk/nvme0n1/nvme0n1p5";

  powerManagement.enable = true;


  boot.kernelParams = ["resume_offset=61440"];

  boot.resumeDevice = "/dev/disk/by-uuid/22364ec8-3373-4fb3-a39c-c7408eb4ef24";

  # boot.initrd.luks.devices."luks-bce853f2-4243-44a9-9384-1569e0adf66d".allowDiscards = true;


  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 18*1024; # 18 gb
    }
  ];

  # Force power button to trigger hibernation
  services.logind.settings.Login = {
    HandleLidSwitch = "hibernate";
    HandlePowerKey = "hibernate";
    HandlePowerKeyLongPress = "poweroff"; # Keep as safety valve to force kill power
  };
  
  systemd.sleep.settings.Sleep = {
    AllowSuspend="no";
    AllowHybridSleep="no";
    AllowSuspendThenHibernate="no";
  };

  # Completely disable standard suspend states in systemd
  # systemd.sleep.extraConfig = ''
  #   AllowSuspend=no
  #   AllowHybridSleep=no
  #   AllowSuspendThenHibernate=no
  # '';
  # DOES NOT WORK, SAYS AT BUILD TIME



  networking.hostName = "redmibook";
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  # Example: HTTP proxy on 127.0.0.1:7890 (adjust port to your FlClashX proxy)
  
  # will make everything depend on flclashx, which is not needed
  networking.proxy.default = "http://127.0.0.1:7890";
  networking.proxy.noProxy = "127.0.0.1,localhost,::1";
  # networking.proxy.socks = "socks5://127.0.0.1:7891"; #doesn't work



  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

   i18n.extraLocaleSettings = {
     LANGUAGE = "en_US.UTF-8";
     LC_ALL = "en_US.UTF-8";
     LC_ADDRESS = "en_US.UTF-8";
     LC_IDENTIFICATION = "en_US.UTF-8";
     LC_MEASUREMENT = "en_US.UTF-8";
     LC_MONETARY = "en_US.UTF-8";
     LC_NAME = "en_US.UTF-8";
     LC_NUMERIC = "en_US.UTF-8";
     LC_PAPER = "en_US.UTF-8";
     LC_TELEPHONE = "en_US.UTF-8";
     LC_TIME = "en_US.UTF-8";
   };

  # Enable the X11 windowing system.

  programs.xfconf.enable = true;



  services.xserver = {
    enable = true;
    digimend.enable = true;

    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
        # noDesktop = true;
        # enableXfwm = false;
      };

    };
    dpi = 192;
    # displayManager.sddm.enable = true;
    # displayManager.sddm.theme = "where-is-my-sddm-theme";

    displayManager.lightdm.enable = true;
    # displayManager.lightdm.greeters.slick.enable = true;

    # displayManager.gdm.enable = true;
    # windowManager.i3 = {
    #   enable = true;
    #     extraPackages = with pkgs; [
    #       dmenu #application launcher most people use
    #       i3status # gives you the default i3 status bar
    #       i3lock #default i3 screen locker
    #       i3blocks #if you are planning on using i3blocks over i3status
    #    ];
    # };
    # synaptics.twoFingerScroll = false;
    # synaptics.scrollDelta = 140;

    #services.xserver.windowManager.awesome.enable = true;
    windowManager.spectrwm.enable = false;
    # Configure keymap in X11
    xkb = {
      layout = "us,ru";
      variant = ",winkeys";
      options = "grp:toggle,caps:escape";
    };
  };
  # services.picom.enable = true;
  # services.displayManager = {
  #   defaultSession = "xfce+dwm";
  # };

  # Enable sound with pipewire.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;
  #  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
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

  # services.fractalart.enable = true;

  # services.logind.extraConfig = "HandlePowerKey=ignore";

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


programs.corectrl.enable = true;

hardware.cpu.x86.msr.enable = true;
hardware.amdgpu.overdrive.enable = true;
systemd.packages = with pkgs; [ lact ];
systemd.services.lactd.wantedBy = ["multi-user.target"];
services.lact.enable = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
 zenstates
 ryzenadj 
    lact
 corectrl 
    distrobox
    xclip
    zsh
    ffmpeg

    # editors
    neovim

    # where-is-my-sddm-theme


    wget
    cmake
    xcape
    wine
    wine64
    winetricks

    gnumake
    harfbuzz
    

    gparted

    # python3Full
    #nvim-pkg
    # pyright
    #tsserver
    # doas
    xfce4-volumed-pulse
    xfce4-pulseaudio-plugin
    xfce4-whiskermenu-plugin
    # android-tools
    #xfce.xfdesktop
    # stylua
    black
    gcc
    git
    home-manager
    openssh
    fzf
    ripgrep
    xclip
    # dxvk vkd3d-proton dxvk-nvapi latencyflex runtime winebridge soda
    # gemini-cli # computer virus
    antigravity



    # (let base = pkgs.appimageTools.defaultFhsEnvArgs; in
    #   pkgs.buildFHSUserEnv (base // {
    #   name = "fhs";
    #   targetPkgs = pkgs: (
    #     # pkgs.buildFHSUserEnv provides only a minimal FHS environment,
    #     # lacking many basic packages needed by most software.
    #     # Therefore, we need to add them manually.
    #     #
    #     # pkgs.appimageTools provides basic packages required by most software.
    #     (base.targetPkgs pkgs) ++ [
    #       pkgs.pkg-config
    #       pkgs.ncurses
    #       pkgs.icu
    #       # Feel free to add more packages here if needed.
    #     ]
    #   );
    #   profile = "export FHS=1";
    #   runScript = "zsh";
    #   extraOutputsToInstall = ["dev"];
    # }))
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
        sansSerif = ["Inter"];
        monospace = ["JetBrains Mono"];
      };
    };
  };

  # services.dwm-status.enable = true;
  # services.dwm-status.order = [ "audio" "battery" "cpu_load" "network" "time" ];

  # services.xserver.windowManager.dwm.enable = true;
  # services.xserver.windowManager.dwm.package = pkgs.dwm.overrideAttrs {
  #  src = pkgs.fetchFromGitHub {
  #    owner = "rteats";
  #    repo = "dwm";
  #    rev = "ed181baf5fce20fdebf9902f728e2101847dd2af";
  #    sha256 = "ZUT+B2/ALJ9lSzC5Bi/Stc9S2aYnilxaAI92SB6U2Is=";
  #    #sha256 = "0/YOL1/G2SWncbLNaclSYUz7VyfWu+OB8TYJYm4NYkM=";
  #      #sha256 = "xbchXJTFWeABTwq6h4KWLh+EvydDrDzcY9AQVK65RS8=";
  #  };
  # };

  stylix = {
    enable = true;
    # overlays.enable = false;
    autoEnable = true;
    image = pkgs.fetchurl {
      url = "https://upload.wikimedia.org/wikipedia/commons/thumb/9/95/Black_Colour.svg/1920px-Black_Colour.svg.png";
      sha256 = "sha256-1sDX3zlpJA7rAwNgcxFsvrrehHaarFgalNe8k5wEruc=";
      # sha256 = lib.fakeSha256;
    };
    base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-light.yaml";
    fonts = {
      sansSerif = {
        package = pkgs.inter;
        name = "Inter";
      };
      monospace = {
        package = pkgs.jetbrains-mono;
        name = "JetBrains Mono";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
      serif = config.stylix.fonts.sansSerif;
    };
    targets = {
      gtk.enable = true;
      # lightdm.enable = true;
    };

  };

  # programs.nix-ld.enable = true;
  # programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
  # ];
  programs.localsend.enable = true;


  programs.noisetorch.enable = true;

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
  programs.appimage.package = pkgs.appimage-run.override 
  {
    extraPkgs = pkgs: 
    [
      pkgs.icu
      pkgs.keybinder
      pkgs.keybinder3
      pkgs.libayatana-appindicator
      pkgs.libayatana-indicator
      pkgs.ayatana-ido
      pkgs.libdbusmenu


      pkgs.libepoxy
      pkgs.libxcrypt-legacy
      pkgs.python312
      pkgs.python312Packages.torch
    ]; 
  };

  services.touchegg.enable = true;

  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  programs.steam.enable = true;

  # obs virtual webcam
  # boot.extraModulePackages = with config.boot.kernelPackages; [
  #   v4l2loopback
  # ];
  # boot.extraModprobeConfig = ''
  #   options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  # '';
  # security.polkit.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.11";
}
