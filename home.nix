{ pkgs, lib, ... }:
{
  imports = [
    ./nix/imports.nix
  ];
  
  home.username = "raphael";
  home.homeDirectory = "/home/raphael";
  home.sessionVariables = {
    GTK_THEME = "Tokyonight-Dark-B";
    # GTK/Electron use logical pixels and are scaled again on Raphael's 1.5x
    # primary monitor. 46 logical px renders at roughly the 69 px compositor
    # cursor size instead of becoming oversized in Discord.
    XCURSOR_THEME = "ArlecchinoChibi-46";
    XCURSOR_SIZE = "46";
    HYPRCURSOR_SIZE = "69";
    XCURSOR_PATH = "/home/raphael/.icons:/home/raphael/.local/share/icons:/run/current-system/sw/share/icons";
  };

  home.stateVersion = "26.11";

  # ArlecchinoChibi ships only 32 px XCursor images. Build a local 46 px
  # variant during Home Manager activation instead of relying on unsupported
  # runtime scaling by Hyprland/GTK.
  home.activation.scaleArlecchinoCursor46 = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.python3}/bin/python ${./scripts/scale_xcursor.py} \
      "$HOME/.icons/ArlecchinoChibi" \
      "$HOME/.local/share/icons/ArlecchinoChibi-46" \
      46
  '';

  gtk = {
    enable = true;
    theme = {
      name = "Tokyonight-Dark-B";
      package = pkgs.tokyonight-gtk-theme;
    };
    # Catppuccin's enabled GTK module owns the Papirus-Dark icon selection;
    # leave it as the single source of truth to avoid a module-priority clash.
    # GTK consumes logical size, which Hyprland scales on the 1.5x display.
    cursorTheme = {
      name = "ArlecchinoChibi-46";
      size = 46;
    };
    gtk3.extraConfig = {
      "gtk-application-prefer-dark-theme" = 1;
    };
    gtk4.extraConfig = {
      "gtk-application-prefer-dark-theme" = 1;
    };
  };

  programs.git = {
    enable = true;
    settings.user = {
      name = "Raphael Hantschk";
      email = "r.hantschk@gmail.com";
    };
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      c = "clear";
      n = "nvim";
      f = "fastfetch";
      home = "cd /home/raphael";
      cd = "z";
      ls = "eza -l";
      cat = "bat";
      hconf = "nvim ~/.config/hypr/hyprland.lua";
      nixdir = "cd /etc/nixos";
    };
    initExtra = ''
      eval "$(zoxide init bash)"
    '';
  };
}
