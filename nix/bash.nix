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
      cat = "bat";
      dwmconf = "nvim /etc/nixos/nix/dwm-rice.nix";
      dwmkeys = "bat /etc/nixos/sys-nix/assets/dwm-config.h";
      sysmon = "btop";
      files = "yazi";
      gitui = "lazygit";
      nixdir = "cd /etc/nixos";
    };
    initExtra = ''
      eval "$(zoxide init bash)"
      if [[ $- == *i* && -z "''${TMUX:-}" && -z "''${FASTFETCH_SHOWN:-}" ]]; then
        FASTFETCH_SHOWN=1 fastfetch
      fi
      newvideo() {
        local dir="/run/media/raphael/SandiskTr/$1"
  
        mkdir -p \
          "$dir/recordings" \
          "$dir/assets/audio" \
          "$dir/assets/images" \
          "$dir/assets/video" \
          "$dir/thumbnail" \
          "$dir/project" \
          "$dir/exports"

        echo "Created: $dir"
      }
    '';
  };
}
