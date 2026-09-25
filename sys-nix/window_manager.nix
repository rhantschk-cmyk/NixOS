{ config, pkgs, lib, ... }:
{
  # Xserver
  programs.hyprland.enable = true;
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
