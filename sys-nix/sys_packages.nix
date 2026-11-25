{ pkgs, ... }:
let
  comfyuiRocm = pkgs.comfyui.override {
    python3 = pkgs.python3.override {
      packageOverrides = _final: prev: {
        torch = prev.torch.override {
          rocmSupport = true;
          gpuTargets = [ "gfx1200" ];
        };
      };
    };
  };
in
{
  nixpkgs.config.allowUnfree = true;

  # System Programs
  environment.systemPackages = with pkgs; [
    libnotify
    libxkbcommon
    openssl
    vim
    wget
    fzf
    ripgrep
    sdl3
    glib
    flatpak
    docker
    comfyuiRocm
    xwayland-satellite
    pkgs.stdenv.cc.cc.lib
    pkgs.libGL
    libX11
  ];

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
