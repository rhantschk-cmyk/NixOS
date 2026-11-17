{ ... }: {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=12";
        promt=">_";
      };
      colors = {
        background = "11111bcc";
        border = "89b4faff";
      };
      border = {
        width = 3;
        radius = 0;
      };
    };
  };
}

