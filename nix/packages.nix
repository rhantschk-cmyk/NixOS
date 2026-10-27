{ pkgs, inputs, ... }:
let
  # Preserve Obsidian's official Electron bundle. The nixpkgs wrapper with
  # electron_43 reproduces the upstream version but still hits a renderer API
  # failure on this workstation.
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

  # AppImage wrappers do not export the upstream desktop entry themselves.
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
  xdg.dataFile."icons/hicolor/scalable/apps/obsidian.svg".source = pkgs.fetchurl {
    url = "https://obsidian.md/images/obsidian-logo-gradient.svg";
    hash = "sha256-EZsBuWyZ9zYJh0LDKfRAMTtnY70q6iLK/ggXlplDEoA=";
  };

  home.packages = with pkgs; [
    # TUIs
    btop
    radeontop
    wiremix
    systemctl-tui
    lazydocker
    gh
    unzip
    davinci-resolve

    # Desktop
    voxtype
    mpv
    tailscale

    # Desktop Programs
    (chromium.override {
      enableWideVine = true;
    })
    obs-studio
    prismlauncher
    lmms
    obsidianUpstream
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.chatgpt

    # Terminal Tools
    zoxide
    bat
    eza
    codex
    appimage-run
    yt-dlp

    # Development
    go
    zig
    gcc
    typescript
    nodejs
    python3
    uv
    electron
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
  
  # User Systemd-Services
  systemd.user.services.voxtype = {
    Unit = {
      Description = "Voxtype Speech-to-Text Daemon";
      After = [ "graphical-session.target" "pipewire.service" ];
      PartOf = [ "graphical-session.target" ];
    };
  
    Service = {
      ExecStart = "${pkgs.voxtype.override { vulkanSupport = true; }}/bin/voxtype";
      Restart = "on-failure";
      RestartSec = 3;
    };
  
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
