{ pkgs, inputs, ... }:
{
  imports = [
    inputs.nixcord.homeModules.nixcord
    inputs.better-git-cli.homeModules.default
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
    (symlinkJoin {
      name = "kdenlive-wrapped";
  
      paths = [ kdePackages.kdenlive ];
  
      nativeBuildInputs = [ makeWrapper ];
  
      postBuild = ''
        wrapProgram $out/bin/kdenlive \
          --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [
            stdenv.cc.cc.lib
            zlib
          ]}
      '';
    })
    prismlauncher
    obsidian

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
