{ pkgs, ... }:
let
  pixelWallpaper = pkgs.writeText "nixos-pixel-grid.svg" ''
    <svg xmlns="http://www.w3.org/2000/svg" width="1920" height="1080" viewBox="0 0 1920 1080">
      <rect width="1920" height="1080" fill="#161821"/>
      <g fill="#1e2030">
        <path d="M0 0h96v96H0zm192 0h96v96h-96zm192 0h96v96h-96zm192 0h96v96h-96zm192 0h96v96h-96zm192 0h96v96h-96zm192 0h96v96h-96zm192 0h96v96h-96zm192 0h96v96h-96zm192 0h96v96h-96z"/>
      </g>
      <g fill="#7aa2f7" opacity=".95">
        <path d="M720 350h96v96h-96zm96 96h96v96h-96zm96 96h96v96h-96zm-96 96h96v96h-96zm-96 96h96v96h-96zm-96-96h96v96h-96zm-96-96h96v96h-96zm96-96h96v96h-96z"/>
      </g>
      <g fill="#bb9af7"><path d="M816 446h96v96h-96zm0 192h96v96h-96z"/></g>
      <text x="960" y="850" text-anchor="middle" fill="#c9d1e8" font-family="JetBrains Mono, monospace" font-size="32" font-weight="bold">NIX // PIXEL // FOCUS</text>
      <text x="960" y="894" text-anchor="middle" fill="#7dcfff" font-family="JetBrains Mono, monospace" font-size="18">DWM SESSION · MOD + P TO LAUNCH</text>
    </svg>
  '';
in
{
  home.packages = with pkgs; [
    btop
    bottom
    bandwhich
    dua
    dysk
    dust
    fd
    fzf
    glow
    gum
    jq
    k9s
    lazygit
    lazydocker
    ncdu
    procs
    ripgrep
    tealdeer
    yazi
  ];

  home.file = {
    ".local/share/backgrounds/nixos-pixel-grid.svg".source = pixelWallpaper;
    ".local/bin/dwm-status" = {
      executable = true;
      text = ''
        #!${pkgs.runtimeShell}
        while true; do
          now="$(${pkgs.coreutils}/bin/date '+%a %d.%m · %H:%M')"
          cpu="$(${pkgs.procps}/bin/uptime | ${pkgs.gnugrep}/bin/grep -o 'load average:.*' | ${pkgs.coreutils}/bin/cut -d: -f2 | ${pkgs.coreutils}/bin/cut -d, -f1 | ${pkgs.coreutils}/bin/xargs)"
          mem="$(${pkgs.procps}/bin/free -h | ${pkgs.gawk}/bin/awk '/^Mem:/ {print $3 "/" $2}')"
          vol="$(${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SINK@ | ${pkgs.gawk}/bin/awk '{printf "%d%%", $2 * 100}')"
          ${pkgs.xorg.xsetroot}/bin/xsetroot -name "  NIX//DWM  |  CPU $cpu  |  RAM $mem  |  VOL $vol  |  $now  "
          sleep 5
        done
      '';
    };
  };

  xdg.configFile = {
    "picom/picom.conf".text = ''
      backend = "glx";
      vsync = true;
      corner-radius = 10;
      rounded-corners-exclude = [ "window_type = 'dock'", "window_type = 'desktop'" ];
      shadow = true;
      shadow-radius = 16;
      shadow-opacity = 0.42;
      shadow-offset-x = -8;
      shadow-offset-y = -8;
      active-opacity = 1.0;
      inactive-opacity = 0.94;
      frame-opacity = 1.0;
      opacity-rule = [ "100:class_g = 'Alacritty'" ];
    '';
    "rofi/config.rasi".text = ''
      configuration {
        modi: "drun,run,window";
        show-icons: true;
        display-drun: "apps";
        display-run: "run";
        font: "JetBrainsMono Nerd Font Bold 12";
        drun-display-format: "{name}";
      }
      * {
        bg: #161821;
        surface: #1e1f2b;
        border: #3b4261;
        fg: #c9d1e8;
        blue: #7aa2f7;
        cyan: #7dcfff;
        purple: #bb9af7;
        background-color: @bg;
        text-color: @fg;
      }
      window { width: 42%; border: 3px; border-color: @blue; border-radius: 12px; background-color: @surface; }
      mainbox { padding: 18px; spacing: 12px; background-color: @surface; }
      inputbar { padding: 12px; border: 0 0 2px 0; border-color: @purple; children: [ prompt, entry ]; }
      prompt { text-color: @cyan; }
      entry { placeholder: "launch something"; placeholder-color: #6e789d; }
      listview { lines: 8; columns: 1; fixed-height: false; }
      element { padding: 10px; border-radius: 8px; }
      element selected { background-color: @blue; text-color: @bg; }
      element-icon { size: 28px; }
    '';
  };
}
