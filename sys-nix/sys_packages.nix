{ pkgs, lib, ... }:
{
  nixpkgs.config.allowUnfree = true;

  # System Programs
  environment.systemPackages = with pkgs; [
    libnotify
    rocmPackages.rocminfo
    rocmPackages.rocm-smi
    libxkbcommon
    noctalia
    openssl
    vim
    wget
    fzf
    ripgrep
    sdl3
    glib
    flatpak
    docker
    xwayland-satellite
    pkgs.stdenv.cc.cc.lib
    pkgs.libGL
    libX11
  ];

  programs.niri.enable = true;
  services.displayManager.defaultSession = lib.mkForce "niri";

  # Global Systemd-Services
  services.tailscale.enable = true;  
  services.openssh.enable = true;
  services.udisks2.enable = true;
  services.syncthing = {
    enable = true;
    user = "raphael";
    dataDir = "/home/raphael";
    configDir = "/home/raphael/.config/syncthing";
  };
}
