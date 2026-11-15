{ pkgs, ... }:
let
  # Start from Raphael's Astronaut reference configuration. Keep its packaged
  # Japanese Aesthetic assets; do not reference a placeholder local image.
  sddmAstronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "japanese_aesthetic";
    themeConfig = {
      HeaderTextColor = "#d5c4a1";
    };
  };
in
{
  environment.systemPackages = [ sddmAstronaut ];

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    package = pkgs.kdePackages.sddm;
    # SDDM only adds runtime QML imports from this explicit list. The theme
    # package supplies SVG/virtual-keyboard dependencies; QtMultimedia must be
    # passed directly so the greeter can resolve its video/audio import.
    extraPackages = with pkgs.kdePackages; [ qtmultimedia ];
    theme = "sddm-astronaut-theme";
    settings.General.Numlock = "on";
  };
}
