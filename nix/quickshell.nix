{ pkgs, ... }:
{
  home.packages = [ pkgs.quickshell ];

  xdg.configFile."quickshell/notch/shell.qml".source = ./quickshell/notch/shell.qml;
}
