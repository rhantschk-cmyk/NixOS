{ pkgs, ... }:
let
  sddm-astronaut = (pkgs.sddm-astronaut.override {
    embeddedTheme = "japanese_aesthetic";  # or any other theme
    themeConfig = {
      # Customize colors and settings
      HeaderTextColor = "#d5c4a1";
      Background = "Backgrounds/your-custom-background.png";
      # ... other theme configuration options
    };
  }).overrideAttrs (oldAttrs: {
    # Optional: Inject custom background image
    installPhase = oldAttrs.installPhase + ''
      chmod u+w $out/share/sddm/themes/sddm-astronaut-theme/Backgrounds/
      cp ${./relative/path/to/your-custom-background.png} \
        $out/share/sddm/themes/sddm-astronaut-theme/Backgrounds/your-custom-background.png
    '';
  });
in
{
  environment.systemPackages = [ sddm-astronaut ];
  
  services.displayManager.sddm = {
    enable = true;
    package = pkgs.kdePackages.sddm;
    extraPackages = with pkgs; [
      kdePackages.qtmultimedia # Required for video backgrounds/audio
    ];
    theme = "sddm-astronaut-theme";
  };
}
