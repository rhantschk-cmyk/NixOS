{ ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      # DP-1 is the larger 4K display. Scale it slightly up, keep it left,
      # and place DP-2 so both physical bottom edges line up.
      monitor = [
        "DP-1,3840x2160@60,0x0,1.1"
        "DP-2,1920x1080@60,3491x884,1"
      ];

      input = {
        kb_layout = "de";
      };
    };
  };
}
