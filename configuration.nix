{ config, lib, pkgs, ... }:

{
  imports =
    [      
      ./hardware-configuration.nix
      ./sys-nix/defaults.nix
    ];
}

