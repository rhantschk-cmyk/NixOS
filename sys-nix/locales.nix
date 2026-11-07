{ ... }:
{
    # Locales
  i18n.defaultLocale = "de_DE.UTF-8";

  # Networking
  networking.hostName = "nix-btw";
  networking.networkmanager.enable = true;

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="096e", ATTR{idProduct}=="0201", MODE="0666"
  '';

  # Timezone
  time.timeZone = "Europe/Berlin";
}
