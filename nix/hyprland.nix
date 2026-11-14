{ ... }:
{
  # Hyprland 0.55+ reads this Lua file before Home Manager's declarative
  # settings backend would run. Keep the live compositor settings here.
  xdg.configFile."hypr/hyprland.lua".text = ''
    hl.monitor({
      output = "DP-1",
      mode = "3840x2160@60",
      position = "0x0",
      scale = 1.1,
    })

    hl.monitor({
      output = "DP-2",
      mode = "1920x1080@60",
      position = "3491x884",
      scale = 1,
    })

    hl.config({
      input = {
        kb_layout = "de",
      },
    })
  '';
}
