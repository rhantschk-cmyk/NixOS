{ pkgs, config, lib, ... }:
{
  services.ollama.enable = true;
  services.ollama.package = pkgs.ollama-vulkan;
  environment.systemPackages = [
    (pkgs.ollama.override {
      acceleration = "vulkan";
    })
  ];
}
