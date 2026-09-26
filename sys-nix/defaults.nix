{ config, lib, pkgs, ... }:
{
  imports = [
    ./sddm.nix
    ./locales.nix
    ./boot_animation.nix
    ./nh.nix
    ./performance.nix
    ./window_manager.nix
    ./steam.nix
    ./ollama.nix
    ./boot.nix
    ./sys_packages.nix
    ./users.nix
  ];

  # VERSION
  virtualisation.docker.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "26.05";
}

