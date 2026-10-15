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
      hconf = "nvim ~/.config/hypr/hyprland.lua";
      nixdir = "cd /etc/nixos";
    };
    initExtra = ''
      eval "$(zoxide init bash)"
      newvideo() {
        local dir="$HOME/Videos/PXL/$1"
  
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
