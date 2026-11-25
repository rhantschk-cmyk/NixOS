{ pkgs, ... }:
{
  services = {
    desktopManager.plasma6.enable = true;
    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true;
  };

  environment.plasma6.excludePackages = with pkgs; [
    kdePackages.kdepim-runtime
  ];

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
