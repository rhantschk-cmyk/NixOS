{ pkgs, ... }:
{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;

    theme = "Elegant";

    settings = {
      General = {
        Numlock = "on";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    elegant-sddm
    kdePackages.sddm-kcm
  ];
}
