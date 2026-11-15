{ pkgs, ... }:
let
  sddmNord = pkgs.sddm-astronaut.override {
    embeddedTheme = "astronaut";
    themeConfig = {
      Font = "JetBrainsMono Nerd Font";
      RoundCorners = "18";
      Background = "Backgrounds/astronaut.png";
      DimBackground = "0.45";
      DimBackgroundColor = "#2E3440";
      FormPosition = "center";
      HaveFormBackground = "true";
      PartialBlur = "true";

      HeaderTextColor = "#ECEFF4";
      DateTextColor = "#D8DEE9";
      TimeTextColor = "#ECEFF4";
      FormBackgroundColor = "#2E3440";
      BackgroundColor = "#2E3440";
      LoginFieldBackgroundColor = "#3B4252";
      PasswordFieldBackgroundColor = "#3B4252";
      LoginFieldTextColor = "#ECEFF4";
      PasswordFieldTextColor = "#ECEFF4";
      UserIconColor = "#88C0D0";
      PasswordIconColor = "#88C0D0";
      PlaceholderTextColor = "#D8DEE9";
      WarningColor = "#BF616A";
      LoginButtonTextColor = "#ECEFF4";
      LoginButtonBackgroundColor = "#5E81AC";
      SystemButtonsIconsColor = "#ECEFF4";
      SessionButtonTextColor = "#ECEFF4";
      VirtualKeyboardButtonTextColor = "#ECEFF4";
      DropdownTextColor = "#ECEFF4";
      DropdownSelectedBackgroundColor = "#4C566A";
      DropdownBackgroundColor = "#3B4252";
      HighlightTextColor = "#ECEFF4";
      HighlightBackgroundColor = "#4C566A";
      HighlightBorderColor = "#88C0D0";
      HoverUserIconColor = "#88C0D0";
      HoverPasswordIconColor = "#88C0D0";
      HoverSystemButtonsIconsColor = "#88C0D0";
      HoverSessionButtonTextColor = "#88C0D0";
      HoverVirtualKeyboardButtonTextColor = "#88C0D0";
    };
  };
in
{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    package = pkgs.kdePackages.sddm;
    theme = "sddm-astronaut-theme";
    # SDDM must receive the theme derivation itself so its wrapped greeter
    # inherits the theme's QML runtime closure, including QtMultimedia.
    extraPackages = [ sddmNord ];
    settings.General.Numlock = "on";
  };

  environment.systemPackages = [ sddmNord ];
}
