{ pkgs, config, ... }:
{
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_zen;
  
  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins;
    motherboard = "intel";
  };
  
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
}
