{ pkgs, inputs, ... }:

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
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    inputs.areofyl-fetch.homeManagerModules.default
  ];
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
    bat.enable = true;
  };

  programs.fetch = {
    enable = true;
    labelColor = "blue";
    info = [ "os" "kernel" "uptime" "memory" ];
    speed = 1.0;
    # spin = "xy";
  };
}

