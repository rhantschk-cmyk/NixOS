{ pkgs,... }:
{
  # Xserver
  services.desktopManager.plasma6 = {
    enable = true;
    enableQt5Integration = true;
  };
  environment.plasma6.excludePackages = 
    with pkgs.kdePackages; [
      konsole
      kate
      elisa
      khelpcenter
      kinfocenter
      kmail
      kaddressbook
      kwalletmanager
      merkuro
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
