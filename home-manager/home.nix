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
    inputs.nixvim.homeManagerModules.nixvim
    #inputs.dwm-flake

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
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
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "user";
    homeDirectory = "/home/user";
  };

  xsession.windowManager.spectrwm = {
    enable = true;
    programs = {
      term = "alacritty";
      search = "rofi ";
      menu = "rofi -show run";
      lock = "xflock4";
    };
    settings = {
      bar_action = "/home/user/.config/polybar/launch.sh";
      bar_enabled = false;
      color_focus = "rgb:10/14/20";
      color_unfocus = "rgb:0/1/10";
    };
  };

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

    # Graphic Design and Editing
    inkscape-with-extensions
    gimp
    libreoffice-still
    neofetch
    ungoogled-chromium
    nsxiv
    kotatogram-desktop

    # Utilities and Development
    lazygit
    unar
    git
    tldr
    fzf
    nnn
    ripgrep
    gh
    yt-dlp
    thefuck

    # Audio and Sound Management
    tenacity
    pavucontrol
    rnnoise-plugin
    noisetorch

    # Miscellaneous
    abaddon
    bottles
  ];


  services.polybar.enable = true;
  services.polybar.script = "polybar bar &";

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
      e = "$EDITOR";
    };
    completionInit = ''
      autoload -Uz compinit && compinit
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
    '';
    autocd = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "fzf" "vi-mode" "aliases" "copyfile" ];
      theme = "robbyrussell";
    };
  };

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    clipboard.providers.xclip.enable = true;
    clipboard.register = "unnamedplus";
    viAlias = true;
    vimAlias = true;
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };
    colorschemes.ayu.enable = true;
    keymaps = [
      { action = "<cmd>nohlsearch<CR>";
        key = "<Esc>";
      }
      { action = ":";
        key = ";";
      }
    ];	

    extraConfigLuaPost = ''
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
      vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
      vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

      local map = vim.api.nvim_set_keymap
      local opts = { noremap = true, silent = true }

      -- Move to previous/next
      map('n', '<C-S-Tab>', '<Cmd>BufferPrevious<CR>', opts)
      map('n', '<C-Tab>', '<Cmd>BufferNext<CR>', opts)
    '';
    autoCmd = [
      { event = [ "TextYankPost" ];
	callback = { __raw = "function() vim.highlight.on_yank() end"; };
      }
    ];
    opts = {
      number = true;         # Show line numbers
      relativenumber = true; # Show relative line numbers
      shiftwidth = 2;        # Tab width should be 2
      mouse = "a";
      showmode = false;
      breakindent = true;
      undofile = true;
      ignorecase = true;
      smartcase = true;
      signcolumn = "yes";
      updatetime = 250;
      timeoutlen = 300;
      splitright = true;
      splitbelow = true;
      list = true;
      listchars = {
        tab = "» ";
        trail = "·";
        nbsp = "␣";
      };
      inccommand = "split";
      cursorline = true;
      scrolloff = 10;
      hlsearch = true;
    };
    plugins = {
      sleuth.enable = true;
      comment.enable = true;
      gitsigns.enable = true;
      which-key.enable = true;
      telescope.enable = true;
      telescope.extensions.ui-select.enable = true;
      lsp.enable = true;
      lsp.servers.pylsp.enable = true;
      lsp.servers.nixd.enable = true;
      lsp.servers.gdscript.enable = true;
      conform-nvim.enable = true;
      cmp.enable = true;
      todo-comments.enable = true;
      mini.enable = true;
      treesitter.enable = true;
      barbar.enable = true;
    };
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
      name = "rupilot";
      src = pkgs.fetchgit {
          url = "https://github.com/Partysun/rupilot.nvim";
          rev = "71f5a94afe50834ea16277bab497da7ca388c712";
          hash = "sha256-zfaE75iZt4PmY1qYi+R5A8L/TJdN2RZnxohEXAr3cSY=";
        };
      })
      pkgs.vimPlugins.nui-nvim
    ];

  };

  #programs.neovim = {
  #   enable = true;
  #   defaultEditor = true;
  #   extraLuaConfig = lib.fileContents ./nvim/init.lua;
    #extraLuaConfig = builtins.readFile ../nvim/init.lua;
    #extraConfig = ''
    #  luafile ${./nvim/init.lua}
    #'';
    #extraLuaConfig = ''
    #  set number relativenumber
    #'';
    #viAlias = true;
    #vimAlias = true;
    #plugins = with pkgs; [
#      vimPlugins.vim-sleuth
#      vimPlugins.comment-nvim
#      vimPlugins.gitsigns-nvim
#      vimPlugins.telescope-nvim
#    ];
#  };

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
        size = 14;
        offset.y = 4;
        glyph_offset.y = 4;
      };
      mouse.hide_when_typing = true;
      colors = {
        # Default colors
        primary = {
          background = "0x0a0e14";
          foreground = "0xb3b1ad";
	};
        # Normal colors
        normal = {
          black =  "0x01060e";
          red =  "0xea6c73";
          green =  "0x91b362";
          yellow =  "0xf9af4f";
          blue =  "0x53bdfa";
          magenta =  "0xfae994";
          cyan =  "0x90e1c6";
          white =  "0xc7c7c7";
	};
        # Bright colors
        bright = {
	  black = "0x686868";
	  blue = "0x59c2ff";
	  cyan = "0x95e6cb";
	  green = "0xc2d94c";
	  magenta = "0xffee99";
	  red = "0xf07178";
	  white = "0xffffff";
	  yellow = "0xffb454";
	};
      };
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
