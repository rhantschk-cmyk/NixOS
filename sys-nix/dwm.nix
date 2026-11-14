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
      # DisplayPort-1 is the 1080p panel at 1×, left of the 4K primary.
      # The 4K panel renders a 2560×1440 logical desktop at 1.5× and both
      # outputs share the same lower edge (1080p starts 360 logical px down).
      ${pkgs.xorg.xrandr}/bin/xrandr \
        --fb 4480x1440 \
        --output DisplayPort-1 --mode 1920x1080 --rate 60.00 --pos 0x360 --scale 1x1 \
        --output DisplayPort-0 --primary --mode 3840x2160 --rate 60.00 --pos 1920x0 --scale-from 2560x1440 \
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
