{ pkgs, inputs, ... }:
{
  imports = [
    inputs.nixcord.homeModules.nixcord
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

    # Desktop
    awww
    voxtype
    rofi
    mpv
    tailscale
    grim
    slurp
    swappy
    ghostty

    # Desktop Programs
    typora
    chromium
    firefox
    nautilus
    obs-studio
    kdePackages.kdenlive
    prismlauncher
    obsidian

    # Terminal Tools
    zoxide
    bat
    eza
    yazi

    # Development
    go
    zig
    lua
    luarocks
    love
    gcc
  ];

  # Programs with extra Config
  programs.nixcord = {
    enable = true;
    discord.vencord.enable = true;
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
