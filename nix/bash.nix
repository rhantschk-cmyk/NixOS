{ ... }: {
  programs.bash = {
    enable = true;
    shellAliases = {
      c = "clear";
      n = "nvim";
      f = "fastfetch";
      home = "cd /home/raphael";
      cd = "z";
      ls = "eza -l";
      nixdir = "cd /etc/nixos";
    };
    initExtra = ''
      eval "$(zoxide init bash)"
      if [[ $- == *i* && -z "''${TMUX:-}" && -z "''${FASTFETCH_SHOWN:-}" ]]; then
        FASTFETCH_SHOWN=1 fastfetch
      fi
    '';
  };
}
