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
  ];
}
