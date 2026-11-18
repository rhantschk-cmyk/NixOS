{ pkgs, ... }:
{
  # Hyprland/Caelestia is the sole desktop session.
  programs.hyprland.enable = true;
  services.displayManager.defaultSession = "hyprland";

  # These must reach SDDM before it spawns Hyprland. Home Manager's shell
  # session variables are too late for the compositor's initial cursor load.
  environment.sessionVariables = {
    XCURSOR_THEME = "ArlecchinoChibi-96";
    XCURSOR_SIZE = "96";
    HYPRCURSOR_SIZE = "96";
  };

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
