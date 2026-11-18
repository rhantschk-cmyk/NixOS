{ pkgs, ... }:
{
  imports = [
    ./nix/imports.nix
  ];
  
  home.username = "raphael";
  home.homeDirectory = "/home/raphael";
  home.sessionVariables = {
    GTK_THEME = "Tokyonight-Dark-B";
    # The assets live in Raphael's persistent user icon directory.
    XCURSOR_THEME = "ArlecchinoChibi";
    # Large enough for the mixed-DPI Hyprland setup and readable from a
    # distance without changing the selected cursor theme.
    XCURSOR_SIZE = "96";
    HYPRCURSOR_SIZE = "96";
    XCURSOR_PATH = "/home/raphael/.icons:/home/raphael/.local/share/icons:/run/current-system/sw/share/icons";
  };

  home.stateVersion = "26.11";

  gtk = {
    enable = true;
    theme = {
      name = "Tokyonight-Dark-B";
      package = pkgs.tokyonight-gtk-theme;
    };
    # Catppuccin's enabled GTK module owns the Papirus-Dark icon selection;
    # leave it as the single source of truth to avoid a module-priority clash.
    # The cursor assets remain in Raphael's persistent ~/.icons directory;
    # XCURSOR_PATH above exposes them to GTK and the wider user session.
    cursorTheme = {
      name = "ArlecchinoChibi";
      size = 96;
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
