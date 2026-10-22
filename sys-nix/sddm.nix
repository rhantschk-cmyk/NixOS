{ pkgs, ... }:
{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;

    theme = "breeze";
    
    settings = {
      General = {
        Numlock = "on";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    kdePackages.sddm-kcm
  ];
}
