# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{ inputs, outputs, lib, config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
#    inputs.hardware.nixosModules.common-ssd
    inputs.home-manager.nixosModules.home-manager
    inputs.nixvim.nixosModules.nixvim
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      # Import your home-manager configuration
      user = import ../home-manager/home.nix;
    };
  };

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
    };
  };

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix.nixPath = ["/etc/nix/path"];
  environment.etc =
    lib.mapAttrs'
    (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry;

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
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

  security.doas = {
    enable = true;
    extraRules = [ { users = ["user"]; persist = true; } ];
  };


  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the XFCE Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

#  services.xserver.windowManager.dwm.package = pkgs.dwm.overrideAttrs {
#    src = /home/user/src/dwm;
#  };

  # Enable DWM
  # services.xserver.windowManager.spectrwm.enable = true;



#  services.xserver.windowManager.dwm.package = pkgs.dwm.overrideAttrs {
#    src = fetchgit {
#      url = "https://github.com/rteats/dwm";
#      hash = "exampleSha256";
#    };
#  };

  # Configure keymap in X11

  services.xserver = {
    layout = "us,ru";
    xkbVariant = ",winkeys";
    xkbOptions = "grp:toggle,caps:escape";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
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

  services.logind.extraConfig = "HandlePowerKey=ignore";

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.blueman.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  users.users = {
    user = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
      ];
      extraGroups = ["networkmanager" "wheel" "audio"];
    };
  };


  users.defaultUserShell = pkgs.zsh;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # editors
    neovim 
    inkscape-with-extensions
    gimp
    kdenlive
    libreoffice-still
    godot_4
    tenacity

    wget
    cmake
    darktile
    spectrwm
    xcape
    wine
    wine64
    winetricks

    gnumake
    reaper
    harfbuzz

    obs-studio
    obs-studio-plugins.obs-backgroundremoval


    python3Full
    pyright
    #tsserver
    doas
    xfce.xfce4-volumed-pulse
    xfce.xfce4-pulseaudio-plugin
    xfce.xfce4-whiskermenu-plugin
    stylua
    zsh
    black
    ungoogled-chromium
    abaddon
    mpv
    gcc
    nsxiv
    gnome.cheese
    hypr

    st

    dwm
    git
    lutris
    pavucontrol
    fswebcam
    home-manager
    dmenu
    sxhkd
    firefox
    openssh
    fzf
    kotatogram-desktop
    nnn
    neofetch
    ripgrep
    rnnoise-plugin
    xclip
    noisetorch

    gh
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


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-media-tags-plugin
        thunar-volman
      ];
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;
  };

  environment.variables.EDITOR = "nvim";


#  programs.zsh = {
#    enable = true;
#    };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  
    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch";
      e = "$EDITOR";
    };
#    history.size = 10000;
#    history.path = "${config.xdg.dataHome}/zsh/history";
      #autoload -Uz compinit && compinit
    shellInit = ''
      autoload -Uz compinit && compinit
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
    '';
   setOptions = [ "autocd" ];    
  };

  programs.nixvim = {
    plugins.lightline.enable = true;
    colorschemes.gruvbox.enable = true;

    opts = {
      g.mapleader = " ";
      g.maplocalleader = " ";
      number = true;
      relativenumber = true;
      mouse = "a";
      showmode = false;
      clipboard = "unnamedplus";
      breakindent = true;
      undofile = true;
      ignorecase = true;
      smartcase = true;
      signcolumn = "yes";
      updatetime = 250;
      
     # -- Decrease mapped sequence wait time
     # -- Displays which-key popup sooner
     # vim.opt.timeoutlen = 300;
     # 
     # -- Configure how new splits should be opened
     # vim.opt.splitright = true
     # vim.opt.splitbelow = true
     # 
     # -- Sets how neovim will display certain whitespace characters in the editor.
     # --  See `:help 'list'`
     # --  and `:help 'listchars'`
     # vim.opt.list = true
     # vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
     # 
     # -- Preview substitutions live, as you type!
     # vim.opt.inccommand = 'split'
     # 
     # -- Show which line your cursor is on
     # vim.opt.cursorline = true
     # 
     # -- Minimal number of screen lines to keep above and below the cursor.
     # vim.opt.scrolloff = 10
     # 
     # -- [[ Basic Keymaps ]]
     # --  See `:help vim.keymap.set()`
     # 
     # -- Set highlight on search, but clear on pressing <Esc> in normal mode
     # vim.opt.hlsearch = true
     # vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
     # 
     # -- Diagnostic keymaps
     # vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
     # vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
     # vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
     # vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
     # 
     # vim.keymap.set('n', ';', ':')
     # 
     # -- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
     # -- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
     # -- is not what someone will guess without a bit more experience.
     # --
     # -- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
     # -- or just use <C-\><C-n> to exit terminal mode
     # vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
     # 
     # -- TIP: Disable arrow keys in normal mode
     # -- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
     # -- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
     # -- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
     # -- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')
     # 
     # -- Keybinds to make split navigation easier.
     # --  Use CTRL+<hjkl> to switch between windows
     # --
     # --  See `:help wincmd` for a list of all window commands
     # vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
     # vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
     # vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
     # vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
     # 
     # -- [[ Basic Autocommands ]]
     # --  See `:help lua-guide-autocommands`
     # 
     # -- Highlight when yanking (copying) text
     # --  Try it with `yap` in normal mode
     # --  See `:help vim.highlight.on_yank()`
     # vim.api.nvim_create_autocmd('TextYankPost', {
     #   desc = 'Highlight when yanking (copying) text',
     #   group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
     #   callback = function()
     #     vim.highlight.on_yank()
     #   end,
     # })
  };
    };

#  programs.fzf = {
#    enable = true;
#    enableZshIntegration = true;
#  };


  # List services that you want to enable:

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      # Forbid root login through SSH.
      PermitRootLogin = "no";
      # Use keys only. Remove if you want to SSH using password (not recommended)
      PasswordAuthentication = false;
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  #
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11"; # Did you read the comment?

}
