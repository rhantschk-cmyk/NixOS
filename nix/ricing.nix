{ config, pkgs, lib, ... }:

let
  # Catppuccin Frappé Farbpalette (ohne # für CLI-Flags)
  frappe = {
    rosewater = "f2d5cf";
    flamingo  = "eebebe";
    pink      = "f4b8e4";
    mauve     = "ca9ee6";
    red       = "e78284";
    maroon    = "ea999c";
    peach     = "ef9f76";
    yellow    = "e5c890";
    green     = "a6d189";
    teal      = "81c8be";
    sky       = "99d1db";
    sapphire  = "85c1dc";
    blue      = "8caaee";
    lavender  = "babbf1";
    text      = "c6d0f5";
    base      = "303446";
    mantle    = "292c3c";
    crust     = "232634";
  };
in
{
  # 1. Globale Catppuccin-Einstellungen (benötigt das catppuccin/nix Flake-Modul)
  catppuccin = {
    enable = true;
    flavor = "frappe";
    accent = "mauve"; # Alternativen: lavender, blue, peach, green, pink etc.
  };

  # 2. Zusätzliche Ricing-Pakete ohne eigene Home-Manager-Module
  home.packages = with pkgs; [
    tty-clock
    lavat
    pipes-rs       # Animierte Terminal-Rohre
    cbonsai        # Wachsender Bonsai-Baum im Terminal
    cmatrix        # Matrix-Regen
    fastfetch      # Schneller System-Info-Fetcher
    eza            # Moderner 'ls'-Ersatz mit Icons
  ];

  # 3. Aliase für Tools, die ihre Farben per Start-Parameter bekommen
  home.shellAliases = {
    # tty-clock: Zentriert (-c), Sekunden (-s), Frappé Mauve (-C 5)
    clock = "tty-clock -c -s -C 5";
    
    # lavat: Lava-Lampe in Frappé Mauve & Pink
    lava = "lavat -c ${frappe.mauve} -k ${frappe.pink} -R 1";
    
    # cbonsai & pipes
    bonsai = "cbonsai -l -i -L 40";
    pipes = "pipes-rs -p 5 -t 0.05";
    
    # Moderne CLI-Tools
    ls = "eza --icons --group-directories-first";
    ll = "eza -la --icons --group-directories-first";
    cat = "bat";
  };

  # 4. Konfigurierte Terminal-Programme (werden automatisch gethemed)
  programs = {
    # Dateimanager
    yazi = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
    };

    # Audio-Visualizer (mit transparentem Hintergrund für Terminal-Blur)
    cava = {
      enable = true;
      catppuccin.transparent = true;
      settings = {
        general = {
          framerate = 60;
          bars = 0; # Automatische Breite
        };
        smoothing = {
          noise_reduction = 77;
        };
      };
    };

    # System-Monitor (htop-Alternative)
    btop = {
      enable = true;
      settings = {
        theme_background = false; # Nutzt Terminal-Transparenz
        vim_keys = true;
      };
    };

    # Terminal-Prompt
    starship = {
      enable = true;
      settings = {
        add_newline = false;
      };
    };

    # Terminal-Multiplexer
    tmux = {
      enable = true;
      mouse = true;
      keyMode = "vi";
      baseIndex = 1;
      catppuccin.extraConfig = ''
        set -g @catppuccin_window_status_style "rounded"
      '';
    };

    # Syntax-Highlighting für 'cat'
    bat.enable = true;

    # Fuzzy Finder (Strg+R für History, Strg+T für Dateien)
    fzf = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
    };

    # Bessere Git-Diffs
    delta = {
      enable = true;
      enableGitIntegration = true;
    };

    # Schnelle Verzeichnis-Sprünge ('z ordnername')
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
    };

    # Terminal-Emulator (z.B. Kitty) für echte Transparenz & Frappé-Basis
    kitty = {
      enable = true;
      font = {
        name = "JetBrainsMono Nerd Font";
        size = 12;
      };
      settings = {
        background_opacity = "0.90";
        window_padding_width = 10;
        confirm_os_window_close = 0;
      };
    };
  };
}

