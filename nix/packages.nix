{ pkgs, inputs, ... }:
let
  codexWithNativeDeps = pkgs.codex.overrideAttrs (old: {
    buildInputs = (old.buildInputs or [ ]) ++ [
      pkgs.aws-lc
      pkgs.oniguruma
      pkgs.sqlite
      pkgs.zstd
    ];
  });

  davinciNixpkgs = import (fetchTarball {
    url = "https://releases.nixos.org/nixos/unstable/nixos-26.11pre1100280.3ec636362e18/nixexprs.tar.zst";
    sha256 = "sha256-17eNBI5Khe4JZaRkL5hRGPWf8MZ6qv+bWAr4V8YeKBw=";
  }) {
    system = pkgs.stdenv.hostPlatform.system;
    config = {
      allowUnfree = true;
    };
  };
  davinciResolveStudioPinned = davinciNixpkgs.davinci-resolve-studio;

  obsidianUpstream = pkgs.appimageTools.wrapType2 {
    pname = "obsidian";
    version = "1.14.5";
    src = pkgs.fetchurl {
      url = "https://github.com/obsidianmd/obsidian-releases/releases/download/v1.14.5/Obsidian-1.14.5.AppImage";
      hash = "sha256-MGgV9g0V3qhhDXKIbvXlDvS35xhelS/8O7Ib7hWC2VI=";
    };
    # The FHS wrapper cannot enter arbitrary caller directories (such as
    # /etc/nixos), so launch it from HOME while preserving all user arguments.
    extraInstallCommands = ''
      mv "$out/bin/obsidian" "$out/bin/.obsidian-real"
      cat > "$out/bin/obsidian" <<'EOF'
      #!${pkgs.runtimeShell}
      cd "''${HOME:?}"
      exec "$(dirname "$(readlink -f "$0")")/.obsidian-real" "$@"
      EOF
      chmod +x "$out/bin/obsidian"
    '';
  };
in
{
  imports = [
    inputs.nixcord.homeModules.nixcord
    inputs.better-git-cli.homeModules.default
    inputs.pxlbot.homeModules.default
  ];

  xdg.desktopEntries.obsidian = {
    name = "Obsidian";
    genericName = "Knowledge base";
    comment = "Knowledge base that works on local Markdown files";
    exec = "obsidian %U";
    icon = "obsidian";
    terminal = false;
    categories = [ "Office" "Utility" ];
    mimeType = [ "x-scheme-handler/obsidian" ];
  };
  xdg.desktopEntries."davinci-resolve-studio" = {
    name = "DaVinci Resolve Studio";
    genericName = "Video Editor";
    comment = "Professional video editing, color, effects and audio post-processing";
    exec = "${davinciResolveStudioPinned}/bin/davinci-resolve-studio";
    icon = "davinci-resolve-studio";
    terminal = false;
    categories = [ "AudioVideo" "AudioVideoEditing" "Video" "Graphics" ];
    settings.StartupWMClass = "resolve";
  };

  xdg.desktopEntries."org.gnome.clocks" = {
    name = "Clocks";
    genericName = "Clocks";
    comment = "Clocks for world times, alarms, stopwatch, and timer";
    exec = "gnome-clocks";
    icon = "org.gnome.clocks";
    terminal = false;
    categories = [ "GNOME" "GTK" "Utility" "Clock" ];
    settings.DBusActivatable = "false";
  };

  xdg.dataFile."icons/hicolor/scalable/apps/obsidian.svg".source = pkgs.fetchurl {
    url = "https://obsidian.md/images/obsidian-logo-gradient.svg";
    hash = "sha256-EZsBuWyZ9zYJh0LDKfRAMTtnY70q6iLK/ggXlplDEoA=";
  };

  home.packages = with pkgs; [
    # TUIs
    wiremix
    lazydocker
    systemctl-tui
    gh
    unzip
    btop

    # Desktop
    mpv
    grim
    slurp
    tailscale
    davinciResolveStudioPinned

    # Desktop Programs
    (chromium.override {
      enableWideVine = true;
    })
    obs-studio
    spotify
    vscodium
    gnome-clocks
    prismlauncher
    lmms
    obsidianUpstream

    # Terminal Tools
    zoxide
    eza
    codexWithNativeDeps
    appimage-run
    yt-dlp
    ffmpeg
    wl-clipboard

    # Development
    go
    zig
    gcc
    typescript
    nodejs
    python3
    uv
    electron
    pkg-config
    cairo
  ];

  # Programs with extra Config
  programs.nixcord = {
    enable = true;
    discord.vencord.enable = true;
  };
  programs.bgt = {
    enable = true;
    browserLogin = false;
  };
  services.pxlbot = {
    enable = true;
    environmentFile = "/home/raphael/.config/pxlbot/bot.env";
  };
}
