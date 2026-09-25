{ pkgs, ... }:

let
  # Wir erstellen eine saubere Textdatei für das ASCII-Art im Nix-Store
  asciiLogo = pkgs.writeText "nixos-logo.txt" ''
   _  ___       ____  ____ 
  / |/ (_)_ __ / __ \/ __/ 
 /    / /\ \ // /_/ /\ \   
/_/|_/_//_\_\ \____/___/   
  '';
in
{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        # Wir übergeben den absoluten Pfad zur generierten Textdatei
        source = "${asciiLogo}";
        padding = {
          right = 4;
          left = 1;
        };
      };
      display = {
        separator = " ➜  ";
        color = {
          keys = "magenta"; 
          title = "magenta";
        };
      };
      modules = [
        "title"
        "break"
        {
          type = "os";
          key = "OS  ";
          keyColor = "35";
        }
        {
          type = "kernel";
          key = "Ker ";
          keyColor = "35";
        }
        {
          type = "uptime";
          key = "Upt ";
          keyColor = "35";
        }
        {
          type = "packages";
          key = "Pkgs";
          keyColor = "35";
        }
        {
          type = "memory";
          key = "RAM ";
          keyColor = "35";
        }
        "break"
        {
          type = "colors";
          symbol = "circle";
        }
      ];
    };
  };
}   
