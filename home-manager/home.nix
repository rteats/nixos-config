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

#  xsession.windowManager.awesome = {
#    enable = true;
#    noArgb = true;
#  };
  xsession.windowManager.spectrwm = {
    enable = true;
    programs = {
      term = "st";
      search = "st";
      menu = "st";
      lock = "xflock4";
    };
    settings = {
      bar_enabled = false;
      color_focus = "rgb:10/14/20";
      color_unfocus = "rgb:0/1/10";
      

    };
  };

  # Add stuff for your user as you see fit:
  home.packages = with pkgs; [ 
    handbrake
    inkscape-with-extensions
    gimp 
    kdenlive
    libreoffice-still
    godot_4
    unar
    tenacity
    reaper
    ungoogled-chromium
    abaddon
    mpv
    nsxiv
    git
    lutris
    tldr
    pavucontrol
    superTuxKart
    fzf
    kotatogram-desktop
    bottles
    nnn
    ripgrep
    rnnoise-plugin
    noisetorch
    gh
    thefuck
    yt-dlp
    (st.overrideAttrs (oldAttrs: rec {
      # Make sure you include whatever dependencies the fork needs to build properly!
      buildInputs = oldAttrs.buildInputs ++ [ harfbuzz ];
    # If you want it to be always up to date use fetchTarball instead of fetchFromGitHub
      src = builtins.fetchTarball {
        url = "https://github.com/rteats/st/archive/master.tar.gz";
	sha256 = "1sx87lix644hfd5q55hrz1hsshxkpfc7k3s13lxrknlsmnd80ig2";
	#sha256 = lib.fakeSha256;
      };
    }))
  ];

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
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;    
        
    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch";
      e = "$EDITOR";
    };
#    history.size = 10000;   
#    history.path = "${config.xdg.dataHome}/zsh/history";
      #autoload -Uz compinit && compinit
    completionInit = ''
      autoload -Uz compinit && compinit
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
    '';
    autocd = true;
   #setOptions = [ "autocd" ];    
#    zplug = {
#      enable = true;
#      plugins = [
#        #{ name = "jeffreytse/zsh-vi-mode"; } # Simple plugin installation
#        #{ name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; } # Installations with additional options. For the list of options, please refer to Zplug README.
#      ];
#    };
    plugins = [
      { 
        name = "zsh-vi-mode";
        src = pkgs.fetchFromGitHub {
          owner = "jeffreytse";
          repo = "zsh-vi-mode";
          rev = "v0.11.0";
          #sha256 = lib.fakeSha256;
          sha256 = "xbchXJTFWeABTwq6h4KWLh+EvydDrDzcY9AQVK65RS8=";
        };
      }
      {
        name = "fzf-tab";
        src = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "v1.1.1";
          #sha256 = lib.fakeSha256;
          sha256 = "0/YOL1/G2SWncbLNaclSYUz7VyfWu+OB8TYJYm4NYkM=";
        };
      }
      {
        name = "ayu";
        src = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "v1.1.1";
          #sha256 = lib.fakeSha256;
          sha256 = "0/YOL1/G2SWncbLNaclSYUz7VyfWu+OB8TYJYm4NYkM=";
        };
      }
    ];
#  initExtraFirst = ''
#    DISABLE_FZF_AUTO_COMPLETION="false"
#  '';
#  oh-my-zsh = {
#    enable = true;
#    plugins = [ "git" "fzf" "thefuck" "vi-mode" "aliases" "copyfile" ];
#    theme = "robbyrussell";
#  };
#  antidote = {
#    enable = true;
#    plugins = [
#      "Aloxaf/fzf-tab"
#    ];
#  };

  };

#  services.xserver.windowManager.dwm.enable = true;
#  services.xserver.windowManager.dwm.package = pkgs.dwm.overrideAttrs {
#    src = pkgs.fetchFromGitHub {
#      owner = "rteats";
#      repo = "dwm";
#      #rev = "v1.1.1";
#          #sha256 = lib.fakeSha256;
#      #sha256 = "0/YOL1/G2SWncbLNaclSYUz7VyfWu+OB8TYJYm4NYkM=";
#        #sha256 = "xbchXJTFWeABTwq6h4KWLh+EvydDrDzcY9AQVK65RS8=";
#    };
#  };

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
        options = {
          silent = true;
        };
      }
      { action = ":";
        key = ";";
      }
    ];	
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
      #sleuth.enable = true;
      comment-nvim.enable = true;
      gitsigns.enable = true;
      which-key.enable = true;
      telescope.enable = true;
      #telescope.extensions.ui-select.enable = true;
      lsp.enable = true;
      lsp.servers.pylsp.enable = true;
      lsp.servers.nixd.enable = true;
      lsp.servers.gdscript.enable = true;
      conform-nvim.enable = true;
      nvim-cmp.enable = true;
      todo-comments.enable = true;
      mini.enable = true;
      treesitter.enable = true;
      barbar.enable = true;
    };
#      plugins.lazy = {
#	enable = true;
#	plugins = with pkgs; [
#	  {
#	    #name = "tpope/vim-sleuth";
#	    pkg = vimPlugins.vim-sleuth;
#	  }
#	];
#      };

   # extraPlugins = with pkgs; [
   #   vimPlugins.neovim-ayu
   #   ];
    #extraPlugins = [ pkgs.vimPlugins.neovim-ayu ];
    #colorscheme = "ayu";
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

 # programs.vscode = {
 #   enable = true;
 #   enableUpdateCheck = false;
 #   enableExtensionUpdateCheck = false;
 #   package = pkgs.vscodium;
 #   extensions = with pkgs; [
 #     vscode-extensions.bbenoist.nix
 #     #vscode-extensions.ms-python.python
 #     vscode-extensions.ms-python.vscode-pylance
 #     vscode-extensions.esbenp.prettier-vscode
#
 #   ];
 # };


  programs.obs-studio = {
    enable = true;
    plugins = with pkgs; [
      obs-studio-plugins.obs-backgroundremoval
    ];
  };
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
