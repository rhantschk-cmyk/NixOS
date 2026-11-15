{ ... }:
{
  # Hyprland 0.55+ reads this Lua file before Home Manager's declarative
  # settings backend would run. Keep the live compositor settings here.
  xdg.configFile."hypr/hyprland.lua".text = ''
    hl.monitor({
      output = "DP-2",
      mode = "1920x1080@60",
      position = "0x540",
      scale = 1,
    })

    hl.monitor({
      output = "DP-1",
      mode = "3840x2160@60",
      position = "1920x0",
      -- Hyprland resolves this to the exact 4/3 scale shown by hyprctl.
      scale = 1.5,
    })

    -- Keep Raphael's numbered workspaces on their intended display.
    for i = 1, 5 do
      hl.workspace_rule({
        workspace = tostring(i),
        monitor = "DP-1",
        persistent = true,
      })
    end

    for i = 6, 9 do
      hl.workspace_rule({
        workspace = tostring(i),
        monitor = "DP-2",
        persistent = true,
      })
    end

    hl.config({
      input = {
        kb_layout = "de",
      },

      general = {
        layout = "dwindle",
        gaps_in = 5,
        gaps_out = 10,
        border_size = 4,
        col = {
          active_border = "rgb(ffffff)",
          inactive_border = "rgba(ffffff33)",
        },
      },

      dwindle = {
        preserve_split = true,
        smart_split = false,
        smart_resizing = true,
      },

      decoration = {
        rounding = 12,
        active_opacity = 1.0,
        inactive_opacity = 0.82,
        blur = {
          enabled = true,
          size = 6,
          passes = 2,
        },
        shadow = {
          enabled = true,
          range = 15,
          render_power = 4,
          color = "rgba(00000055)",
        },
      },

      animations = {
        enabled = true,
      },
    })

    -- Reapply Raphael's OpenRGB profile at compositor start and shutdown.
    local openrgbProfile = "openrgb -p sdwn"
    hl.on("hyprland.start", function()
      hl.dispatch(hl.dsp.exec_cmd(openrgbProfile))
    end)
    hl.on("hyprland.shutdown", function()
      hl.dispatch(hl.dsp.exec_cmd(openrgbProfile))
    end)

    -- Medium-fast motion: noticeably quicker than stock Hyprland without
    -- making workspace/window changes feel abrupt.
    hl.curve("standard", { type = "bezier", points = { { 0.2, 0 }, { 0, 1 } } })
    hl.curve("emphasizedAccel", { type = "bezier", points = { { 0.3, 0 }, { 0.8, 0.15 } } })
    hl.curve("emphasizedDecel", { type = "bezier", points = { { 0.05, 0.7 }, { 0.1, 1 } } })

    hl.animation({ leaf = "windowsIn", enabled = true, speed = 7, bezier = "emphasizedDecel" })
    hl.animation({ leaf = "windowsOut", enabled = true, speed = 6, bezier = "emphasizedAccel" })
    hl.animation({ leaf = "windowsMove", enabled = true, speed = 8, bezier = "standard" })
    hl.animation({ leaf = "workspaces", enabled = true, speed = 7, bezier = "standard" })
    hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "standard" })
    hl.animation({ leaf = "border", enabled = true, speed = 7, bezier = "standard" })

    local repeating = { repeating = true }
    local mouse = { mouse = true }
    local locked = { locked = true }

    -- Raphael's core bindings.
    for i = 1, 9 do
      hl.bind("SUPER + " .. i, hl.dsp.focus({ workspace = tostring(i) }))
      hl.bind("SUPER + ALT + " .. i, hl.dsp.window.move({ workspace = tostring(i) }))
    end

    hl.bind("SUPER + W", hl.dsp.window.close())
    hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
    hl.bind("SUPER + SHIFT + Q", hl.dsp.exit())
    hl.bind("SUPER + RETURN", hl.dsp.exec_cmd("alacritty"))
    hl.bind("SUPER + SHIFT + RETURN", hl.dsp.exec_cmd("chromium"))
    hl.bind("SUPER + E", hl.dsp.exec_cmd("davinci-resolve-studio"))
    hl.bind("SUPER + C", hl.dsp.exec_cmd("code"))
    hl.bind("SUPER + SPACE", hl.dsp.global("caelestia:launcher"))
    hl.bind("SUPER + SHIFT + F", hl.dsp.window.float())

    for _, direction in ipairs({ "left", "right", "up", "down" }) do
      hl.bind("SUPER + " .. direction, hl.dsp.window.move({ direction = direction }), repeating)
      hl.bind("SUPER + SHIFT + " .. direction, hl.dsp.focus({ direction = direction }), repeating)
    end

    hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), mouse)
    hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), mouse)

    -- Useful Caelestia/Hyprland defaults retained around the custom layer.
    hl.bind("SUPER + SUPER_L", hl.dsp.global("caelestia:launcher"), { release = true })
    hl.bind("ALT + TAB", hl.dsp.window.cycle_next(), repeating)
    hl.bind("SHIFT + ALT + TAB", hl.dsp.window.cycle_next({ next = false }), repeating)
    hl.bind("SUPER + L", hl.dsp.global("caelestia:lock"))
    hl.bind("SUPER + N", hl.dsp.global("caelestia:sidebar"))
    hl.bind("SUPER + K", hl.dsp.global("caelestia:showall"))
    hl.bind("SUPER + V", hl.dsp.exec_cmd("pkill fuzzel || caelestia clipboard"))
    hl.bind("SUPER + ALT + V", hl.dsp.exec_cmd("pkill fuzzel || caelestia clipboard -d"))
    hl.bind("SUPER + Period", hl.dsp.exec_cmd("pkill fuzzel || caelestia emoji -p"))
    hl.bind("Print", hl.dsp.exec_cmd("caelestia screenshot"), locked)
    hl.bind("SUPER + SHIFT + S", hl.dsp.global("caelestia:screenshotFreeze"))
    hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"))

    hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), locked)
    hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 10%+"), { locked = true, repeating = true })
    hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-"), { locked = true, repeating = true })
    hl.bind("XF86AudioPlay", hl.dsp.global("caelestia:mediaToggle"), locked)
    hl.bind("XF86AudioPause", hl.dsp.global("caelestia:mediaToggle"), locked)
    hl.bind("XF86AudioNext", hl.dsp.global("caelestia:mediaNext"), locked)
    hl.bind("XF86AudioPrev", hl.dsp.global("caelestia:mediaPrev"), locked)
  '';
}
