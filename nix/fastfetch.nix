{ pkgs, ... }:
let
  asciiLogo = pkgs.writeText "raphael-nix-pixel-logo.txt" ''
       ▄▄▄▄  ▄  ▄  ▄   ▄
      ██  ██ ██▄██ ██   ██
      ██  ██ ██ ██ ██▄█ ██
       ▀▀▀▀  ▀  ▀  ▀▀▀  ▀▀

       N I X  ·  P I X E L
  '';
in
{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "${asciiLogo}";
        padding = { right = 4; left = 1; };
      };
      display = {
        separator = " 󰒋 ";
        color = { keys = "blue"; title = "magenta"; };
      };
      modules = [
        "title"
        { type = "custom"; format = "  NIX // PIXEL // FOCUS"; outputColor = "cyan"; }
        "break"
        { type = "os"; key = "OS   "; keyColor = "35"; }
        { type = "host"; key = "Host "; keyColor = "35"; }
        { type = "kernel"; key = "Ker  "; keyColor = "35"; }
        { type = "uptime"; key = "Upt  "; keyColor = "35"; }
        { type = "packages"; key = "Pkgs "; keyColor = "35"; }
        { type = "shell"; key = "Sh   "; keyColor = "35"; }
        { type = "terminal"; key = "Term "; keyColor = "35"; }
        { type = "wm"; key = "WM   "; keyColor = "35"; }
        { type = "memory"; key = "RAM  "; keyColor = "35"; }
        "break"
        { type = "colors"; symbol = "circle"; }
      ];
    };
  };
}
