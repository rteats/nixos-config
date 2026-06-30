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
    inputs.nix4nvchad.homeManagerModule
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
      # inputs.antigravity-nix.overlays.default

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
      # GDK_SCALE = "2";
      # GDK_DPI_SCALE = "0.5";
      QT_SCALE_FACTOR = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      MOZ_USE_XINPUT2 = "1";
    };
  };

  programs.nvchad = {
    enable = true;
    hm-activation = true; # Automatically provisions and clears stale states
    
    # Bypasses Mason by injecting system binaries straight into NvChad's PATH
    extraPackages = with pkgs; [
      # Essential Core tools for Telescope and parsing
      ripgrep
      fd
      gnumake
      gcc

      # Add your LSPs and Formatters here
      nixd
      lua-language-server
      stylua
    ];
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

  # programs.lutris.enable = true;
  # programs.lutris.winePackages = [
  #   pkgs.wineWow64Packages.stableFull
  # ];



  # Add stuff for your user as you see fit:
  home.packages = with pkgs; [
    # Multimedia and Creative Tools
    # handbrake
    # kdenlive
    # godot_4
    # reaper
    mpv
    mangojuice
    mangohud
    ayugram-desktop
    unar
    file
    bottles
    # obs-studio
    # superTuxKart
    # polybar
    # lutris
    # blender

    

    # Graphic Design and Editing
    inkscape-with-extensions
    # inkscape
    gimp
    # libreoffice-still
    fastfetch

    # chromium
    nsxiv
    jq
    libnotify
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


    # google-antigravity-cli
    lazygit
    ouch
    git
    tldr
    fzf
    nnn
    ripgrep
    qbittorrent
    rqbit

    # gh
    # yt-dlp
    ytfzf
    pay-respects
    bat
    imagemagick
    # gpu-screen-recorder
    # gpu-screen-recorder-gtk

    ncdu
    # transmission_4-gtk
    bash
    zathura
    github-cli
    
    # Wine and Gaming Compatibility
    winetricks
    # zenity
    # cabextract

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
    # python312Packages.flake8
    # arandr

    zbar
    zed-editor-fhs

    # Fonts
    inter
    jetbrains-mono
    intel-one-mono
    montserrat
    # proxychains-ng
  ];
  
  # Define the proxychains configuration file
  # xdg.configFile."proxychains/proxychains.conf".text = ''
  #   # proxychains.conf
  #   # strict_chain
  #   # proxy_dns
  #   # remote_dns_subnet 224
  #   # tcp_read_time_out 15000
  #   # tcp_connect_time_out 8000
  #
  #   [ProxyList]
  #   # protocol host port
  #   socks5 127.0.0.1 7890
  # '';
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
  programs.foot = {
    enable = true;
    settings = {
  main = {
    # dpi-aware = "yes"; 

    font = pkgs.lib.mkForce "JetBrains Mono:size=11, Font Awesome 6 Free:size=11, Font Awesome 6 Brands:size=11";
    # term = "xterm-256color";
  };
  mouse = {
    hide-when-typing = "yes";
  };
};
  };

programs.waybar = {
  enable = true;

  settings = {
    mainBar = {
      reload_style_on_change = true;
      toggle = true;
      layer = "top";
      position = "left";
      margin-top = 0;
      margin-bottom = 0;
      margin-left = 0;
      margin-right = 0;
      spacing = 0;

      modules-left = [ "wlr/taskbar"  ];
      modules-center = [  ];
      modules-right = [
        "group/extras"
	"mpris"
	"cpu"
	"privacy"
	"custom/proxy"  # Added here
        "network"
        "bluetooth"
        "pulseaudio#microphone"
        "group/audio"
        "group/brightness"
        "battery"
	"custom/language" # Added right here
	"clock"
      ];

      "group/extras" = {
        orientation = "inherit";
        drawer = {
          transition-duration = 400;
          children-class = "extras";
          transition-left-to-right = false;
        };
        modules = [
          "custom/menu"
          "tray"
        ];
      };

      "group/brightness" = {
        orientation = "inherit";
        drawer = {
          transition-duration = 400;
          children-class = "brightness";
          transition-left-to-right = false;
        };
        modules = [
          "backlight"
          "backlight/slider"
        ];
      };

      "group/audio" = {
        orientation = "inherit";
        drawer = {
          transition-duration = 400;
          children-class = "audio";
          transition-left-to-right = false;
        };
        modules = [
          "pulseaudio"
          "pulseaudio/slider"
        ];
      };

      "custom/cachy" = {
        format = "";
        tooltip = false;
        on-click = "foot";
        on-click-right = "kitty";
      };

      "wlr/taskbar" = {
        format = "{icon}";
        icon-size = 18;
        tooltip-format = "{title}";
        on-click = "activate";
        on-click-middle = "close";
        sort-by-app-id = true;
      };

      "cpu" = {
        format = "{icon}";
        format-icons = [
          "<span size='14pt'>󰄰</span>"
          "<span size='14pt'>󰪞</span>"
          "<span size='14pt'>󰪟</span>"
          "<span size='14pt'>󰪠</span>"
          "<span size='14pt'>󰪡</span>"
          "<span size='14pt'>󰪢</span>"
          "<span size='14pt'>󰪣</span>"
          "<span size='14pt'>󰪤</span>"
          "<span size='14pt'>󰪥</span>"
        ];
        interval = 1;
        tooltip = true;
        tooltip-format = "CPU Frequency: {avg_frequency} GHz";
        on-click = "foot -e btm";
      };

      "clock" = {
        interval = 1;
        format = "{:%H\n%M}";
        format-alt = "{:%d\n%m\n%y}";
        tooltip-format = "<tt><small>{calendar}</small></tt>";
      };

      "mpris" = {
        format = "<span size='14pt'>󰐎</span>";
        interval = 1;
        on-click = "playerctl play-pause";
        on-click-right = "playerctl next";
        on-click-middle = "playerctl previous";
        tooltip = true;
        tooltip-format = "{title}";
      };

      "custom/menu" = {
        format = "<span size='16pt'>󰅃</span>";
        tooltip = false;
      };

      "tray" = {
        spacing = 16;
        reverse-direction = true;
        icon-size = 16;
        show-passive-items = false;
      };

      "privacy" = {
        icon-size = 14;
        transition-duration = 250;
        modules = [
          {
            type = "screenshare";
            tooltip = false;
          }
        ];
        ignore = [
          {
            type = "screenshare";
            name = "obs";
          }
        ];
      };


"custom/proxy" = {
        interval = 2;
        return-type = "json";
        format = "{}";
        tooltip = true;
        tooltip-format = "Left-click: Toggle Proxy Mode\nRight-click: Select Low-Latency Server";
        
        # Background loop tracking core mode state
        exec = let
          curl = "${pkgs.curl}/bin/curl";
          jq = "${pkgs.jq}/bin/jq";
        in ''
          resp=$(${curl} -s http://127.0.0.1:9090/configs 2>/dev/null)
          if [ -z "$resp" ]; then
            echo '{"text":"ERR","class":"error"}'
          else

            echo "$resp" | ${jq} -c 'if .mode then {text: (if .mode == "rule" then "󰒘" else "󰒙" end), class: .mode} else {"text":"ERR","class":"error"} end' 2>/dev/null || echo '{"text":"ERR","class":"error"}'
          fi
        '';

        # LEFT-CLICK: Toggle mode behavior state
        on-click = let
          curl = "${pkgs.curl}/bin/curl";
          jq = "${pkgs.jq}/bin/jq";
          pkill = "${pkgs.procps}/bin/pkill";
        in ''
          mode=$(${curl} -s http://127.0.0.1:9090/configs | ${jq} -r .mode 2>/dev/null)
          if [ "$mode" = "rule" ]; then
            next="Direct"
          else
            next="Rule"
          fi
          ${curl} -s -X PATCH http://127.0.0.1:9090/configs -H "Content-Type: application/json" -d "{\"mode\": \"$next\"}"
          ${curl} -s -X DELETE http://127.0.0.1:9090/connections
          ${pkill} -RTMIN+4 waybar
        '';

        # RIGHT-CLICK: Open interactive low-latency Rofi selector list
        on-click-right = let
          curl = "${pkgs.curl}/bin/curl";
          jq = "${pkgs.jq}/bin/jq";
          rofi = "${pkgs.rofi}/bin/rofi";
        in ''
          # 1. Trigger strict 1000ms health check to update delay stats
          ${curl} -s "http://127.0.0.1:9090/group/GLOBAL/delay?url=http://cp.cloudflare.com/generate_204&timeout=1000" > /dev/null

          resp=$(${curl} -s http://127.0.0.1:9090/proxies 2>/dev/null)
          if [ -z "$resp" ] || [ "$resp" = "null" ]; then
              exit 0
          fi

          # 2. Compile ALL servers responding under 1000ms, omitting DIRECT and Россия
          ALL_SERVERS=$(echo "$resp" | ${jq} -r '
            if .proxies then
              [ .proxies[] 
                | select(.history and (.history | length) > 0 and .type != "Selector" and .type != "URLTest" and .type != "Fallback") 
                | {name: .name, delay: .history[-1].delay}
                | select(.delay > 0 and .name != "DIRECT" and (.name | contains("Россия") | not))
              ] 
              | sort_by(.delay) 
              | .[] 
              | "\(.delay) ms | \(.name)"
            else
              empty
            end
          ')

          if [ -z "$ALL_SERVERS" ]; then
              exit 0
          fi

          # 3. Present choices inside the interactive Rofi window
          CHOICE=$(echo "$ALL_SERVERS" | ${rofi} -dmenu -p "Select Server" -i)
          if [ -z "$CHOICE" ]; then
              exit 0
          fi

          # Isolate the exact server name string by pruning the delay prefix
          SELECTED_SERVER=$(echo "$CHOICE" | sed 's/^[0-9]* ms | //')

          # 4. Extract selector groups into an unreserved variable name
          PROXY_GROUPS=$(echo "$resp" | ${jq} -r 'if .proxies then .proxies | to_entries[] | select(.value.type == "Selector") | .key else empty end')

          # 5. Apply updates safely across every group layout using a hardened string container
          if [ -n "$PROXY_GROUPS" ]; then
              JSON_PAYLOAD=$(${jq} -nc --arg n "$SELECTED_SERVER" '{name: $n}')

              while IFS= read -r group; do
                  [ -z "$group" ] && continue
                  ENCODED_GROUP=$(${jq} -rn --arg g "$group" '$g | @uri')
                  
                  # Verify if this specific selector group actually contains our target node option
                  if ${curl} -s "http://127.0.0.1:9090/proxies/$ENCODED_GROUP" | ${jq} -e --arg target "$SELECTED_SERVER" 'if .all then .all[] | select(. == $target) else false end' > /dev/null; then
                      # Apply the new server selection choice
                      ${curl} -s -X PUT "http://127.0.0.1:9090/proxies/$ENCODED_GROUP" \
                           -H "Content-Type: application/json" \
                           -d "$JSON_PAYLOAD"
                  fi
              done <<< "$PROXY_GROUPS"
          fi

          # 6. Flush open sockets so browsers/apps immediately adapt to the path change
          ${curl} -s -X DELETE http://127.0.0.1:9090/connections
        '';

        signal = 4;
      };

      "network" = {
        format-icons = {
          wifi = [
            "<span size='12pt'>󰤯</span>"
            "<span size='12pt'>󰤟</span>"
            "<span size='12pt'>󰤢</span>"
            "<span size='12pt'>󰤥</span>"
            "<span size='12pt'>󰤨</span>"
          ];
          ethernet = "<span size='12pt'>󰈀</span>";
          disabled = "<span size='12pt'>󰤮</span>";
          disconnected = "<span size='12pt'>󰤫</span>";
        };
        format-wifi = "{icon}";
        format-ethernet = "{icon}";
        format-disconnected = "{icon}";
        format-disabled = "{icon}";
        interval = 5;
        tooltip-format = "{essid}\t{gwaddr}";
        on-click = "rfkill toggle wifi";
        on-click-right = "nm-connection-editor";
        tooltip = true;
        max-length = 20;
      };

      "bluetooth" = {
        interval = 5;
        format-on = "<span size='14pt'>󰂯</span>";
        format-off = "<span size='14pt'>󰂲</span>";
        format-disabled = "<span size='14pt'>󰂲</span>";
        format-connected = "<span size='14pt'>󰂱</span>";
        format-no-controller = "<span size='14pt'>󰂯</span>";
        tooltip = true;
        tooltip-format = "{device_enumerate}";
        tooltip-format-enumerate-connected = "{device_address}";
        tooltip-format-enumerate-connected-battery = "{device_address} | Battery: {device_battery_percentage}%";
        on-click = "rfkill toggle bluetooth";
        on-click-right = "blueman-manager";
      };

      "pulseaudio#microphone" = {
        format = "{format_source}";
        format-source = "<span size='14pt'>󰍬</span>";
        format-source-muted = "<span size='14pt'>󰍭</span>";
        on-click = "pactl set-source-mute @DEFAULT_SOURCE@ toggle";
        on-click-right = "pavucontrol -t 4";
        tooltip = false;
      };

      "pulseaudio/slider" = {
        min = 0;
        max = 100;
        orientation = "vertical";
      };

      "pulseaudio" = {
        interval = 1;
        format = "{icon}";
        format-icons = [
          "<span size='14pt'>󰕿</span>"
          "<span size='14pt'>󰖀</span>"
          "<span size='14pt'>󰕾</span>"
        ];
        format-muted = "<span size='14pt'>󰝟</span>";
        on-click-right = "pavucontrol -t 3";
        on-click = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
        reverse-scrolling = true;
        tooltip = true;
        tooltip-format = "Volume: {volume}%\n{desc}";
        ignored-sinks = [
          "Easy Effects Sink"
        ];
      };

      "backlight/slider" = {
        min = 0;
        max = 100;
        orientation = "vertical";
        device = "intel_backlight";
      };

      "backlight" = {
        device = "intel_backlight";
        format = "{icon}";
        format-icons = [
          "󰃞"
          "󰃟"
          "󰃠"
        ];
        reverse-scrolling = true;
        smooth-scrolling-threshold = 0.2;
        tooltip = false;
      };

# "battery" = {
#         interval = 5;
#         states = {
#           critical = 10;
#         };
#         format = "{capacity}%";
#         format-charging = "{capacity}%";
#         format-plugged = "{capacity}%";
#         format-critical = "{capacity}%";
#         tooltip = true;
#         tooltip-format = "Charge: {capacity}%";
#         tooltip-format-charging = "Charging: {capacity}%";
#       };

"battery" = {
        interval = 5;
        states = {
          critical = 10;
        };
        format = "<span size='14pt'>{icon}</span>";
        format-charging = "<span size='14pt'>{icon}</span>"; # Changed to look up dynamic charging icons
        format-plugged = "<span size='14pt'>󱐥</span>";
        format-critical = "<span size='14pt'>󱃍</span>";
        
        # Split icons into structured sub-arrays
        format-icons = {
          charging = [
            "󰢜" # Charging 10%
            "󰂆" # Charging 20%
            "󰂇" # Charging 30%
            "󰂈" # Charging 40%
            "󰢝" # Charging 50%
            "󰂉" # Charging 60%
            "󰢞" # Charging 70%
            "󰂊" # Charging 80%
            "󰂋" # Charging 90%
            "󰂅" # Charging 100%
          ];
          default = [
            "󰁺" # Discharging steps (Your original set)
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
        };
        tooltip = true;
        tooltip-format = "Charge: {capacity}%";
        tooltip-format-charging = "Charging: {capacity}%";
      };

      "custom/powermenu" = {
        format = "<span size='13pt'>󰐥</span>";
        on-click = "$HOME/.config/rofi/powermenu/powermenu.sh";
        tooltip = false;
      };
    };
  };

style = ''
    /* Color Definitions */
    @define-color cursor #CDD6F4;
    @define-color background #000000;
    @define-color foreground #CDD6F4;
    @define-color color0  #45475A;
    @define-color color1  #F38BA8;
    @define-color color2  #A6E3A1;
    @define-color color3  #F9E2AF;
    @define-color color4  #89B4FA;
    @define-color color5  #F5C2E7;
    @define-color color6  #94E2D5;
    @define-color color7  #BAC2DE;
    @define-color color8  #585B70;
    @define-color color9  #F38BA8;
    @define-color color10 #A6E3A1;
    @define-color color11 #F9E2AF;
    @define-color color12 #89B4FA;
    @define-color color13 #F5C2E7;
    @define-color color14 #94E2D5;
    @define-color color15 #A6ADC8;

    /* Base Styles */
    * {
      font-family: "JetBrainsMono Nerd Font Propo";
      font-size: 16px;
      border-radius: 0;
      box-shadow: none;
    }

    window#waybar {
      background: @background;
    }

    #custom-cachy:hover,
    #cpu:hover,
    #network:hover,
    #bluetooth:hover,
    #pulseaudio:hover,
    #pulseaudio.microphone:hover,
    #pulseaudio.sink-muted:hover,
    #custom-powermenu:hover {
      opacity: 0.5;
    }

    #custom-cachy,
    #cpu,
    #clock,
    #mpris,
    #custom-menu,
    #tray,
    #privacy,
    #network,
    #bluetooth,
    #pulseaudio,
    #pulseaudio.microphone,
    #backlight,
    #battery,
    #custom-powermenu {
      color: @foreground;
      padding: 6px 0;
    }

    #workspaces button {
      color: @foreground;
      padding: 0;
    }
    #workspaces button.active {
      color: @color2;
    }

    #privacy {
      margin: 4px;
      color: @color3;
    }

    #clock {
      color: @color4;
    }

    #mpris {
      color: @color3;
    }

    #network.disabled {
      color: @color1;
    }
    #network.wifi {
      color: @color2;
    }
    #network.ethernet {
      color: @color3;
    }

    #bluetooth.disabled {
      color: @color1;
    }
    #bluetooth.connected {
      color: @color4;
    }

    #pulseaudio.sink-muted:not(.microphone) {
      color: @color3;
    }
    #pulseaudio.microphone.source-muted {
      color: @color1;
    }

    #battery.plugged {
      color: @color4;
    }
    #battery.charging {
      color: @color2;
    }
    #battery.critical {
      color: @color3;
    }

    tooltip {
      background: @background;
      border: 1px solid @foreground;
    }
    tooltip * {
      color: @foreground;
      margin: 2px;
      background: @background;
    }

    #pulseaudio-slider,
    #backlight-slider {
      min-height: 80px;
    }

    #pulseaudio-slider slider,
    #backlight-slider slider {
      background: transparent;
    }

    #pulseaudio-slider trough,
    #backlight-slider trough {
      min-width: 8px;
    }

    #pulseaudio-slider highlight {
      background: @color4;
    }
    #backlight-slider highlight {
      background: @color3;
    }

#custom-proxy {
      font-weight: bold;
      padding: 6px 0;
    }

    #custom-proxy.rule {
      color: @color2; /* Green text when smart rules are working */
    }

    #custom-proxy.direct {
      color: @color14; /* Cyan/Teal text when bypassing the proxy */
    }

    #custom-proxy.error {
      color: @color1; /* Red text if FlClash core API is dead */
    }
    
    #custom-proxy:hover {
      opacity: 0.5;
    }
    /* Taskbar Icon Container Tracking */
    #taskbar {
      padding: 4px 0;
    }

    #taskbar button {
      padding: 6px 0;
      color: @foreground;
    }

    /* Highlight the window that currently has keyboard/mouse focus */
    #taskbar button.active {
      color: @color2; /* Matches your active workspace light green accent */
      border-left: 2px solid @color2;
    }

    #taskbar button:hover {
      opacity: 0.5;
      background: transparent;
    }
  '';
};
  # home.nix
  programs.git = {
    enable = true;
    settings.user = {
      name = "rteats";
      email = "rteatsrteats@gmail.com";
    };
    # Tell Git to format signatures using SSH
    settings = {
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

  programs.lsd = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };


  stylix.targets.librewolf.profileNames = [ "default" ];
  programs.librewolf = {
    enable = true;
    settings = {
      "privacy.resistFingerprinting.letterboxing" = true;
    };
    profiles = {
      default = {  # This is your <PROFILE_NAME>. It could be "default", your username, etc.
        # your bookmarks, settings, and extensions go here
      };
    };
    policies = {
      BlockAboutConfig = false;
      DefaultDownloadDirectory = "\${home}/Downloads";
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          default_area = "menupanel";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
      };
    };

  };

  # programs.firefox = {
  #   enable = true;
  #   profiles.user = {
  #     settings = {
  #       "apz.allow_zooming" = true;
  #       "apz.gtk.touchpad_pinch.enabled" = true;
  #       "dom.w3c_touch_events.enabled" = 1;
  #       "browser.gesture.pinch.enabled" = true;
  #     };
  #   };
  # };

  programs.chromium = {
    enable = true;
    # commandLineArgs = [
    #   "--enable-features=TouchpadPinch"
    # ];
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
      # "Gdk/WindowScalingFactor" = 2; # Double the UI element sizes
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
      # sizes.terminal = 24;
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


  # xdg.configFile."autostart/flclashx.desktop".text = ''
  #   [Desktop Entry]
  #   Type=Application
  #   Name=FlClashX
  #   Exec=bash -c "/run/current-system/sw/bin/appimage-run /home/user/Desktop/FlClashX-linux-amd64.AppImage"
  #   X-GNOME-Autostart-enabled=true
  # '';
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
    # shellAliases = {
    #   ll = "ls -l";
    #   e = "lvim";
    # };
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

#   programs.neovim = {
#     enable = true;
#     defaultEditor = true;
#   #   extraLuaConfig = lib.fileContents ./nvim/init.lua;
#     #extraLuaConfig = builtins.readFile ../nvim/init.lua;
#     #extraConfig = ''
#     #  luafile ${./nvim/init.lua}
#     #'';
#     #extraLuaConfig = ''
#     #  set number relativenumber
#     #'';
#     viAlias = true;
#     vimAlias = true;
#     #plugins = with pkgs; [
# #      vimPlugins.vim-sleuth
# #      vimPlugins.comment-nvim
# #      vimPlugins.gitsigns-nvim
# #      vimPlugins.telescope-nvim
# #    ];
#   };

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
