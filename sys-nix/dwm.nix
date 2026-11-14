{ pkgs, ... }:
let
  raphaelDwm = pkgs.dwm.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      cp ${./assets/dwm-config.h} config.h
    '';
  });
in
{
  # Plasma remains enabled in window_manager.nix and stays selectable in SDDM.
  services.xserver.windowManager.dwm = {
    enable = true;
    package = raphaelDwm;
    extraSessionCommands = ''
      # Keep both outputs at their native pixel grids. XRandR's fractional
      # resampling made the 4K panel visibly soft, so UI sizing is handled by
      # application/font settings instead of a scaled output transform.
      ${pkgs.xorg.xrandr}/bin/xrandr \
        --fb 5760x2160 \
        --output DisplayPort-1 --mode 1920x1080 --rate 60.00 --pos 0x1080 --scale 1x1 \
        --output DisplayPort-0 --primary --mode 3840x2160 --rate 60.00 --pos 1920x0 --scale 1x1 \
        --output HDMI-A-0 --off
      ${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name left_ptr
      ${pkgs.feh}/bin/feh --no-fehbg --bg-fill "$HOME/.local/share/backgrounds/nixos-pixel-grid.svg" &
      ${pkgs.picom}/bin/picom --config "$HOME/.config/picom/picom.conf" &
      "$HOME/.local/bin/dwm-status" &
    '';
  };

  environment.systemPackages = with pkgs; [
    brightnessctl
    dmenu
    feh
    picom
    rofi
    xclip
    xdotool
    xorg.xrandr
  ];
}
