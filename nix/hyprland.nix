{ pkgs, lib, config, ... }:
{
  xdg.configFile."hypr/hyprland.lua".text = ''
    ---------------------------------------
    ---   Hyprland Lua
    ---------------------------------------
    
    
    --- Variables (syntax: local variable = value)
    
    local terminal = "ghostty"
    local browser = "firefox"
    local files = "nautilus"
    local editor = "typora"
    local rgb = "openrgb -p std"
    local quickshell = "quickshell"
    local menu = "/home/raphael/.config/rofi/scripts/menu.sh"
    local wallpaper_daemon = "awww-daemon & disown"
    
    --- Autostart (syntax (inside the function below): hl.exec( tool ))
    
    hl.on("hyprland.start", function()
        hl.exec_cmd(rgb)
        hl.exec_cmd(quickshell)
	hl.exec_cmd("systemctl --user start nixos-fake-graphical-session.target")
        hl.exec_cmd(wallpaper_daemon)
    end)
    
    hl.on("hyprland.shutdown", function()
        hl.exec_cmd("openrgb -p sdwn")
    end)
    
    --- Environment Variables (syntax: hl.env( name, value ))
    hl.env("XCURSOR_SIZE", "24")
    hl.env("HYPRCURSOR_SIZE", "24")
    
    --- Permissions (syntax: hl.permission({ binary, type, mode })
    
    --- Monitors (syntax: hl.monitor({ output, mode, posiotion, scale }))
    
    hl.monitor({
            output = "DP-1",
            mode = "3840x2160@60",
            position = "1920x0",
            scale = "1.5",
    })
    
    hl.monitor({
            output = "DP-2",
            mode = "1920x1080@60",
            position = "0x360",
            scale = "1",
    })
    
    --- Look
    
    hl.config({
            general = {
                    gaps_in = 3,
                    gaps_out = 4,
                    border_size = 3,
                    resize_on_border = false,
                    allow_tearing = false,
                    layout = "dwindle",
            },
    
            decoration = {
                    rounding = 0,
                    rounding_power = 2,
                    active_opacity = 1.0,
                    inactive_opacity = 1.0,
    
                    shadow = {
                            enabled = true,
                            range = 4,
                            render_power = 3,
                            color = 0xee1a1a1a,
                    },
    
                    blur = {
                            enabled = true,
                            size = 3,
                            passes = 1,
                            vibrancy = 0.1696,
                    },
            },
    
            animations = {
                    enabled = true,
            },
    })
    
    -- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
    hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
    hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
    hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
    hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
    hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })
    
    -- Default springs
    hl.curve("easy",           { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })
    
    hl.animation({ leaf = "global",        enabled = true,  speed = 5,   bezier = "default" })
    hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
    hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, spring = "easy" })
    hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  spring = "easy",         style = "popin 87%" })
    hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
    hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
    hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
    hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
    hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
    hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
    hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
    hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
    hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
    hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
    hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "almostLinear", style = "fade" })
    hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
    hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick" })
    
    
    --- Windowrules (syntax: see examples)
    
    -- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
    -- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
    -- hl.window_rule({
    --     name  = "no-gaps-wtv1",
    --     match = { float = false, workspace = "w[tv1]" },
    --     border_size = 0,
    --     rounding    = 0,
    -- })
    -- hl.window_rule({
    --     name  = "no-gaps-f1",
    --     match = { float = false, workspace = "f[1]" },
    --     border_size = 0,
    --     rounding    = 0,
    -- })
    
    
    --- Extras
    
    hl.config({
            dwindle = {
                    preserve_split = true, -- IMPORTANT
            },
    })
    
    hl.config({
            master = {
                    new_status = "master" -- ALSO IMPORTANT
            },
    })
    
    hl.config({
            scrolling = {
                    fullscreen_on_one_column = true,
            },
    })
    
    --- Misc
    
    hl.config({
            misc = {
                    disable_splash_rendering = true,
                    force_default_wallpaper = 2,
                    always_follow_on_dnd = false,
            },
    })
    
    --- Input
    
    hl.config({
            input = {
                    kb_layout = "de",
            },
    })
    
    --- Keybinds (syntax: hl.bind( key1 " + " key 2 " + " ..., hl.dsp.exec_cmd() / hl.dsp.window.move() / ...) )
    
    local mainMod = "SUPER"
    
    -- Execute Apps
    hl.bind(mainMod .. " + SHIFT + F", hl.dsp.exec_cmd(files))
    hl.bind(mainMod .. " +  SPACE", hl.dsp.exec_cmd(menu))
    hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
    hl.bind(mainMod .. " + SHIFT + RETURN", hl.dsp.exec_cmd(browser))
    hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(editor))
    hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("ghostty -e 'btop'", {float = true}))
    hl.bind(mainMod .. " + O", hl.dsp.exec_cmd("obsidian"))
    
    -- Execute Webapps
    hl.bind(mainMod .. " + SHIFT + Y", hl.dsp.exec_cmd("gio launch /home/raphael/.local/share/applications/youtube.desktop"))
    hl.bind(mainMod .. " + SHIFT + A", hl.dsp.exec_cmd("gio launch /home/raphael/.local/share/applications/chatgpt.desktop"))
    hl.bind(mainMod .. " + SHIFT + G", hl.dsp.exec_cmd("gio launch /home/raphael/.local/share/applications/github.desktop"))
    hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd("gio launch /home/raphael/.local/share/applications/gmail.desktop"))
    
    -- Quit Hyprland
    hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
    
    -- Magic Workspace Actions
    hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
    hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic"}))
    hl.bind(mainMod .. " + ALT + S", hl.dsp.window.move({ workspace = "e+0"}))
    
    -- Move Window Actions
    hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({action = "toggle", mode = "fullscreen"}))
    hl.bind(mainMod .. " + V", hl.dsp.window.float({action = "toggle"}))
    hl.bind(mainMod .. " + W", hl.dsp.window.close())
    hl.bind(mainMod .. " + right", hl.dsp.window.move({direction="right"}))
    hl.bind(mainMod .. " + left", hl.dsp.window.move({direction="left"}))
    hl.bind(mainMod .. " + up", hl.dsp.window.move({direction="up"}))
    hl.bind(mainMod .. " + down", hl.dsp.window.move({direction="down"}))
    hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag())
    
    -- Group Actions
    hl.bind(mainMod .. " + G", hl.dsp.group.toggle())
    hl.bind(mainMod .. " + TAB", hl.dsp.group.next())
    
    -- Hardware Keys
    hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
    hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%-"))
    hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"))
    
    
    -- Move focus with mainMod + arrow keys
    hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.focus({ direction = "left" }))
    hl.bind(mainMod .. " + SHIFT + right", hl.dsp.focus({ direction = "right" }))
    hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.focus({ direction = "up" }))
    hl.bind(mainMod .. " +  SHIFT + down",  hl.dsp.focus({ direction = "down" }))
    
    -- Switch workspaces with mainMod + [0-9]
    -- Move active window to a workspace with mainMod + SHIFT + [0-9]
    for i = 1, 10 do
            local key = i % 10 -- 10 maps to key 0
            hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
            hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
    end
    
    -- Windows & Workspaces (später)
    
    for i = 1, 8 do
            if i <= 5 then
                    hl.workspace_rule({ workspace = tostring(i), monitor = "DP-1" })
            else
                    hl.workspace_rule({ workspace = tostring(i), monitor = "DP-2" })
            end
    end
    '';
}
