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

  home = {
    username = "user";
    homeDirectory = "/home/user";
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

  # Add stuff for your user as you see fit:
  home.packages = with pkgs; [
    # Multimedia and Creative Tools
    handbrake
    kdenlive
    godot_4
    reaper
    mpv
    superTuxKart
    polybar
    lutris
    blender

    # Graphic Design and Editing
    inkscape-with-extensions
    gimp
    libreoffice-still
    neofetch
    chromium
    nsxiv
    #kotatogram-desktop
    telegram-desktop
    mypaint
    krita

    # Utilities and Development
    lazygit
    ouch
    git
    tldr
    fzf
    nnn
    ripgrep
    gh
    yt-dlp
    ytfzf
    thefuck
    bat
    imagemagick
    ncdu
    transmission_4-gtk
    bash
    lunarvim
    zathura
    python312Packages.cairosvg
    jdk22

    # Audio and Sound Management
    tenacity
    pavucontrol
    rnnoise-plugin
    noisetorch

    # Communication
    abaddon
    armcord

    # Miscellaneous
    bottles
    python312Packages.flake8
    arandr

    # Fonts
    inter
    jetbrains-mono
    intel-one-mono
    montserrat
  ];
  
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

  stylix = {
    enable = true;
    autoEnable = true;
    image = pkgs.fetchurl {
      url = "https://upload.wikimedia.org/wikipedia/commons/thumb/5/50/Black_colour.jpg/450px-Black_colour.jpg";
      sha256 = "BFbiwE4KpDf9oXmZ7UyZVuDimhI9kCHhbP+nqhB+eGQ=";
      # sha256 = lib.fakeSha256;
    };
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Original-Classic";
      size = 20;
    };
    base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-dark.yaml";
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
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      serif = config.stylix.fonts.sansSerif;
      sizes.terminal = 10;
    };
    targets = {
      xfce.enable = true;
      gtk.enable = true;
    };

  };

  gtk.iconTheme = {
    package = pkgs.papirus-icon-theme;
    name = "Papirus-Dark";
  };

  xfconf.settings = {
    xfce4-power-manager = {
      "xfce4-power-manager/brightness-exponential" = true;
    };
  };

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


  # services.polybar.enable = true;
  # services.polybar.script = "polybar bar &";

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName  = "rteats";
    userEmail = "rteatsrteats@gmail.com";
    extraConfig = {
      commit.gpgsign = true;
      gpg.format = "ssh";
      user.signingkey = "/home/user/.ssh/id_ed25519.pub";
    };
  };

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
      plugins = [ "git" "ripgrep" "themes" "z" "zsh-interactive-cd" "fzf" "vi-mode" "aliases" "copyfile" ];
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

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs; [
      obs-studio-plugins.obs-backgroundremoval
    ];
  };

  programs.rofi = {
    enable = true;
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        # size = 14;
        offset.y = 4;
        glyph_offset.y = 4;
      };
      selection.save_to_clipboard = true;
      mouse.hide_when_typing = true;
      # colors = {
      #   # Default colors
      #   primary = {
      #     background = "0x0a0e14";
      #     foreground = "0xb3b1ad";
      #   };
      #   # Normal colors
      #   normal = {
      #     black =  "0x01060e";
      #     red =  "0xea6c73";
      #     green =  "0x91b362";
      #     yellow =  "0xf9af4f";
      #     blue =  "0x53bdfa";
      #     magenta =  "0xfae994";
      #     cyan =  "0x90e1c6";
      #     white =  "0xc7c7c7";
      #   };
      #   # Bright colors
      #   bright = {
      #     black = "0x686868";
      #     red = "0xf07178";
      #     blue = "0x59c2ff";
      #     cyan = "0x95e6cb";
      #     green = "0xc2d94c";
      #     magenta = "0xffee99";
      #     white = "0xffffff";
      #     yellow = "0xffb454";
      #   };
      # };
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
  home.stateVersion = "23.05";
}
