{ pkgs, inputs, ... }:
{
  imports = [
    inputs.nixcord.homeModules.nixcord
    inputs.better-git-cli.homeModules.default
    inputs.pxlbot.homeModules.default
  ];

  home.packages = with pkgs; [
    # TUIs
    btop
    radeontop
    bluetuith
    wiremix
    ncdu
    duf
    dust
    systemctl-tui
    lazygit
    lazydocker
    gh
    claude-code
    unzip
    davinci-resolve

    # Desktop
    voxtype
    mpv
    tailscale
    ghostty

    # Desktop Programs
    chromium
    obs-studio
    prismlauncher
    obsidian
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.chatgpt

    # Terminal Tools
    zoxide
    bat
    eza
    yazi
    codex
    appimage-run

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
