{ pkgs, lib, ... }:
{
  imports = [
    ./nix/imports.nix
  ];
  
  home.username = "raphael";
  home.homeDirectory = "/home/raphael";
  home.sessionVariables = {
    GTK_THEME = "Tokyonight-Dark-B";
    # Electron is still doubling the 46 px logical XCursor in Discord. Keep
    # that client-side size at 23 px while Hyprland uses its own 69 px cursor.
    XCURSOR_THEME = "ArlecchinoChibi-23";
    XCURSOR_SIZE = "23";
    HYPRCURSOR_SIZE = "69";
    XCURSOR_PATH = "/home/raphael/.icons:/home/raphael/.local/share/icons:/run/current-system/sw/share/icons";
  };

  home.stateVersion = "26.11";

  # ArlecchinoChibi ships only 32 px XCursor images. Build local 23 px (apps)
  # and 46 px (Hyprland source) variants during Home Manager activation.
  # This avoids relying on unsupported runtime scaling by Hyprland/GTK.
  home.activation.scaleArlecchinoCursorThemes = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.python3}/bin/python ${./scripts/scale_xcursor.py} \
      "$HOME/.icons/ArlecchinoChibi" \
      "$HOME/.local/share/icons/ArlecchinoChibi-46" \
      46
    ${pkgs.python3}/bin/python ${./scripts/scale_xcursor.py} \
      "$HOME/.icons/ArlecchinoChibi" \
      "$HOME/.local/share/icons/ArlecchinoChibi-23" \
      23
  '';

  gtk = {
    enable = true;
    theme = {
      name = "Tokyonight-Dark-B";
      package = pkgs.tokyonight-gtk-theme;
    };
    # Catppuccin's enabled GTK module owns the Papirus-Dark icon selection;
    # leave it as the single source of truth to avoid a module-priority clash.
    # Discord/Electron doubles the client-side XCursor size in this session.
    cursorTheme = {
      name = "ArlecchinoChibi-23";
      size = 23;
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
