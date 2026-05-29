# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule
    #inputs.nixvim.homeManagerModules.nixvim
    #inputs.dwm-flake
    #inputs.nix-nvim
    # inputs.boomer

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default
      # nix-nvim.overlays.default
      #inputs.nix-nvim.overlays.default
      # inputs.dwm-flake.overlays.default
      # inputs.boomer.overlays.default

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
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home.sessionVariables = {
  };
  home = {
    username = "user";
    homeDirectory = "/home/user";
    sessionVariables = {
      # Replace with your actual proxy address and port
      HTTP_PROXY = "http://127.0.0.1:7890";
      HTTPS_PROXY = "http://127.0.0.1:7890";
      ALL_PROXY = "socks5://127.0.0.1:7890";
      
      # Lowercase versions are also recommended as some tools look for them specifically
      http_proxy = "http://127.0.0.1:7890";
      https_proxy = "http://127.0.0.1:7890";
      all_proxy = "socks5://127.0.0.1:7890";

      # Bypass the proxy for local traffic
      NO_PROXY = "localhost,127.0.0.1,localaddress,.localdomain.com";
      no_proxy = "localhost,127.0.0.1,localaddress,.localdomain.com";
      GDK_SCALE = "2";
      GDK_DPI_SCALE = "0.5";
      QT_SCALE_FACTOR = "2";
      QT_AUTO_SCREEN_SCALE_FACTOR = "2";
    };
  };



  # xsession.windowManager.spectrwm = {
  #   enable = true;
  #   programs = {
  #     term = "alacritty";
  #     search = "rofi ";
  #     menu = "rofi -show run";
  #     lock = "xflock4";
  #   };
  #   settings = {
  #     bar_action = "/home/user/.config/polybar/launch.sh";
  #     bar_enabled = false;
  #     color_focus = "rgb:10/14/20";
  #     color_unfocus = "rgb:0/1/10";
  #     modkey = "Mod4";
  #     #bind[firefox]		= MOD+Shift+b

  #   };
  #   bindings = {
  #     menu = "Mod+d";
  #   };
  # };

  # xsession.windowManager.i3 = {
  #   enable = true;
  #   package = pkgs.i3-gaps;
  #   config = {
  #     modifier = "Mod4";
  #     gaps = {
  #       inner = 10;
  #       outer = 5;
  #     };
  #   };
  # };
  fonts.fontconfig.enable = true;

  # Workaround home-manager bug with flakes
  # - https://github.com/nix-community/home-manager/issues/2033
  news.display = "silent";

  programs.antigravity.enable = true;

  # Add stuff for your user as you see fit:
  home.packages = with pkgs; [
    # Multimedia and Creative Tools
    # handbrake
    # kdenlive
    # godot_4
    # reaper
    mpv
    mangojuice
    ayugram-desktop
    # superTuxKart
    # polybar
    # lutris
    # blender

    

    # Graphic Design and Editing
    inkscape-with-extensions
    # inkscape
    gimp
    libreoffice-still
    fastfetch
    # chromium
    nsxiv
    #kotatogram-desktop
    # telegram-desktop
    # mypaint
    # krita
    htop
    gotop
    btop

    # Utilities and Development
    keepassxc
    syncthingtray-minimal
    # gparted

    syncthing


    lazygit
    ouch
    git
    tldr
    fzf
    nnn
    ripgrep
    # gh
    # yt-dlp
    ytfzf
    pay-respects
    bat
    imagemagick
    ncdu
    # transmission_4-gtk
    bash
    zathura
    github-cli

    # python312Packages.cairosvg
    # jdk22

    # Audio and Sound Management
    # tenacity
    pavucontrol
    rnnoise-plugin
    noisetorch

    # Communication
    # abaddon
    # armcord

    # Miscellaneous
    # bottles
    # python312Packages.flake8
    # arandr

    # Fonts
    inter
    jetbrains-mono
    intel-one-mono
    montserrat
    proxychains-ng
  ];
  
  # Define the proxychains configuration file
  xdg.configFile."proxychains/proxychains.conf".text = ''
    # proxychains.conf
    strict_chain
    proxy_dns
    remote_dns_subnet 224
    tcp_read_time_out 15000
    tcp_connect_time_out 8000
    
    [ProxyList]
    # protocol host port
    socks5 127.0.0.1 7890
  '';
  # fonts = {
  #   enableDefaultPackages = true;
  #   packages = with pkgs; [
  #     inter
  #     jetbrains-mono
  #     intel-one-mono
  #     montserrat
  #   ];
    # fontconfig = {
    #   defaultFonts = {
    #     #serif = [ "Vazirmatn" "Ubuntu" ];
    #     sansSerif = ["Inter"];
    #     monospace = ["JetBrains Mono"];
    #   };
    # };
  # };

  # home.nix
  programs.git = {
    enable = true;
    settings.user = {
      name = "rteats";
      email = "rteatsrteats@gmail.com";
    };
    # Tell Git to format signatures using SSH
    extraConfig = {
      gpg.format = "ssh"; 
    };
  
    # Point directly to your public key string or public key path
    signing = {
      key = "${config.home.homeDirectory}/.ssh/id_ed25519.pub"; 
      # Alternatively, you can use a file path:
      # key = "${config.home.homeDirectory}/.ssh/id_ed25519.pub"; 
      signByDefault = true;
    };
  };


  programs.chromium = {
    enable = true;
    package = pkgs.chromium;
    extensions = [
      { id="ddkjiahejlhfcafbddmgiahcphecmpfh";} 
      { id="bmhfelbhbkeoldaiphchjibggnoodpcj";} 
      { id="jghecgabfgfdldnmbfkhmffcabddioke";} 
    ];
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    plugins = {
        ouch = pkgs.fetchFromGitHub {
          owner = "ndtoan96";
          repo = "ouch.yazi";
          rev = "694d149be5f96eaa0af68d677c17d11d2017c976";
          # sha256 = lib.fakeSha256;
          sha256 = "J3vR9q4xHjJt56nlfd+c8FrmMVvLO78GiwSNcLkM4OU=";
        };
    };

  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "Bibata-Original-Classic"; # Replace with your cursor theme
    size = 64;                       # Set your desired cursor size here
  };



  xfconf.settings = {
    xfce4-desktop = {
      "backdrop/screen0/monitor0/workspace0/color-style" = 0; # Solid color or None
      # "backdrop/screen0/monitor0/workspace0/image-style" = 5; # Centered, Scaled, or Tiled (5 for Zoomed)
      # "backdrop/screen0/monitor0/workspace0/last-image" = "/home/your_username/Pictures/your-wallpaper.jpg";
    };
    xfce4-power-manager = {
      # 3 = Hibernate in XFCE's internal mapping
      "xfce4-power-manager/power-button-action" = 3; 

      # Optional: If you also want it to hibernate when closing the lid
      "xfce4-power-manager/lid-action-on-battery" = 3;
      "xfce4-power-manager/lid-action-on-ac" = 3;

      # Prevent XFCE from overriding with standard suspend
      "xfce4-power-manager/critical-power-action" = 3; 

      "xfce4-power-manager/brightness-exponential" = false;
    };
    xsettings = {
      "Gdk/WindowScalingFactor" = 2; # Double the UI element sizes
      "Gtk/CursorThemeSize" = 64;    # Prevent the mouse cursor from shrinking
    };
    xfwm4 = {
      "general/theme" = "Default-xhdpi"; # Scale up window borders and title bars
    };
    # Alternatively, for xfce4-settings based on libinput
    # pointers = {
    #   "xfce4-pointer-settings"
    # };
    pointers = {
      "ELAN231000_04F33238_Touchpad/ReverseScrolling" = true;
      "ELAN231000_04F33238_Touchpad/Acceleration" = 6.0;
      "ELAN231000_04F33238_Touchpad/Threshold" = 1;
      "ELAN231000_04F33238_Touchpad/RightHanded" = true;
    };
  };

  stylix = {
    overlays.enable = false;

    enable = true;
    autoEnable = true;
    image = pkgs.fetchurl {
      url = "https://upload.wikimedia.org/wikipedia/commons/thumb/9/95/Black_Colour.svg/1920px-Black_Colour.svg.png";
      sha256 = "sha256-1sDX3zlpJA7rAwNgcxFsvrrehHaarFgalNe8k5wEruc=";
      # sha256 = lib.fakeSha256;
    };
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Original-Classic";
      size = 64;
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
      sizes.terminal = 24;
    };
    targets = {
      xfce.enable = true;
      # gtk.enable = true;
    };

  };

  gtk.iconTheme = {
    package = pkgs.papirus-icon-theme;
    name = "Papirus-Light";
  };


  xdg.configFile."autostart/flclashx.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=FlClashX
    Exec=bash -c "/run/current-system/sw/bin/appimage-run /home/user/Desktop/FlClashX-linux-amd64.AppImage"
    X-GNOME-Autostart-enabled=true
  '';
  xdg.mimeApps = {
    enable= true;
    defaultApplications = {
      "application/pdf" = [ "zathura.desktop" "chromium.desktop" ];
      "image/png" = [ "sxiv.desktop" "gimp.desktop" ];
      "application/x-zerosize"=[ "nvim.desktop" ];
      "application/vnd.microsoft.portable-executable"=[ "winetricks.desktop" ];
      "x-scheme-handler/magnet"=[ "userapp-transmission-gtk-3BIDP2.desktop" ];
      # "application/pdf"=[ "org.pwmt.zathura-pdf-mupdf.desktop" ];
      
      "x-scheme-handler/tg"=[ "org.telegram.desktop.desktop" ];
      # "application/pdf"=[ org.pwmt.zathura-pdf-mupdf.desktop ];

    };

  };


  # Fixes legacy/standalone X11 application fonts
  xresources.properties = {
    "Xft.dpi" = 192;
  };

  services.syncthing = {
    enable = true;
  };

  # services.polybar.enable = true;
  # services.polybar.script = "polybar bar &";

  # Enable home-manager and git
  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ll = "ls -l";
      e = "lvim";
    };
    completionInit = ''
      autoload -Uz compinit && compinit
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
    '';
    autocd = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "themes" "z" "zsh-interactive-cd" "fzf" "vi-mode" "aliases" "copyfile" ];
      theme = "robbyrussell";
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  #   extraLuaConfig = lib.fileContents ./nvim/init.lua;
    #extraLuaConfig = builtins.readFile ../nvim/init.lua;
    #extraConfig = ''
    #  luafile ${./nvim/init.lua}
    #'';
    #extraLuaConfig = ''
    #  set number relativenumber
    #'';
    viAlias = true;
    vimAlias = true;
    #plugins = with pkgs; [
#      vimPlugins.vim-sleuth
#      vimPlugins.comment-nvim
#      vimPlugins.gitsigns-nvim
#      vimPlugins.telescope-nvim
#    ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # programs.obs-studio = {
  #   enable = true;
  #   plugins = with pkgs; [
  #     obs-studio-plugins.obs-backgroundremoval
  #   ];
  # };

  programs.rofi = {
    enable = true;
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        # size = 14;
        # offset.y = 4;
        # glyph_offset.y = 4;
      };
      selection.save_to_clipboard = true;
      mouse.hide_when_typing = true;
      window.dimensions = {
              lines = 30;
              columns = 200;
            };
	window.startup_mode = "Maximized";
    };
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
    mouse = true;
    terminal = "screen-256color";
    plugins = with pkgs; [
      # tmuxPlugins.tpm
      tmuxPlugins.sensible
      tmuxPlugins.yank
      tmuxPlugins.pain-control
      tmuxPlugins.resurrect
      tmuxPlugins.prefix-highlight
    ];
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "26.05";
}
