{ ... }:
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
    # 68 px is approximately twice the visible cursor area of the former
    # 48 px setting while preserving the same theme.
    XCURSOR_SIZE = "68";
    HYPRCURSOR_SIZE = "68";
    XCURSOR_PATH = "/home/raphael/.icons:/home/raphael/.local/share/icons:/run/current-system/sw/share/icons";
  };

  home.stateVersion = "26.11";

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
