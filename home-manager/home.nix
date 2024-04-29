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

  # TODO: Set your username
  home = {
    username = "user";
    homeDirectory = "/home/user";
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
    obs-studio
    obs-studio-plugins.obs-backgroundremoval
    ungoogled-chromium
    abaddon
    mpv
    nsxiv
    git
    lutris
    tldr
    pavucontrol
    fzf
    kotatogram-desktop
    nnn
    ripgrep
    rnnoise-plugin
    noisetorch
    gh
    thefuck
    yt-dlp
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName  = "rteats";
    userEmail = "rteatsrteats@gmail.com";
  };

  programs.zsh = {
    enable = true;    
    enableCompletion = true;
    #enableAutosuggestions = true;
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
          #sha256 = "xbchXJTFWeABTwq6h4KWLh+EvydDrDzcY9AQVK65RS8=";
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

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    #extraConfig = lib.fileContents ;
    #extraConfig = ''
    #  set number relativenumber
    #'';
    #viAlias = true;
    #vimAlias = true;
    #plugins = with pkgs; [
    #  vimPlugins.vim-sleuth
    #  vimPlugins.comment-nvim
    #  vimPlugins.gitsigns-nvim
    #  vimPlugins.telescope-nvim
    #];
  };
 
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

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
