{ pkgs, ... }:
{
  # Hyprland/Caelestia is the sole desktop session.
  programs.hyprland.enable = true;
  services.displayManager.defaultSession = "hyprland";

  documentation.enable = false;
  services.xserver = {
    enable = true;
    xkb.layout = "de";
  };
  console.keyMap = "de";

  # Sound
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
}
