{ pkgs, lib, ... }:
{
  imports = [
    ./nix/imports.nix
  ];
  
  home.username = "raphael";
  home.homeDirectory = "/home/raphael";
  home.sessionVariables = {
    GTK_THEME = "Tokyonight-Dark-B";
    XCURSOR_THEME = "ArlecchinoChibi-69";
    XCURSOR_SIZE = "69";
    HYPRCURSOR_SIZE = "69";
    XCURSOR_PATH = "/home/raphael/.icons:/home/raphael/.local/share/icons:/run/current-system/sw/share/icons";
  };

  home.stateVersion = "26.11";

  # ArlecchinoChibi ships only 32 px XCursor images. Build a local 69 px
  # variant during Home Manager activation instead of relying on unsupported
  # runtime scaling by Hyprland/GTK.
  home.activation.scaleArlecchinoCursor = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.python3}/bin/python ${./scripts/scale_xcursor.py} \
      "$HOME/.icons/ArlecchinoChibi" \
      "$HOME/.local/share/icons/ArlecchinoChibi-69" \
      69
  '';

  gtk = {
    enable = true;
    theme = {
      name = "Tokyonight-Dark-B";
      package = pkgs.tokyonight-gtk-theme;
    };
    # Catppuccin's enabled GTK module owns the Papirus-Dark icon selection;
    # leave it as the single source of truth to avoid a module-priority clash.
    # The generated 69 px variant is available before the next graphical login.
    cursorTheme = {
      name = "ArlecchinoChibi-69";
      size = 69;
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
