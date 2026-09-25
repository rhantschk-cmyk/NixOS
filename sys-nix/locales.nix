{ config, lib, ... }:
{
    # Locales
  i18n.defaultLocale = "de_DE.UTF-8";

  # Networking
  networking.hostName = "nix-btw";
  networking.networkmanager.enable = true;

  # Timezone
  time.timeZone = "Europe/Berlin";
}
