{pkgs, ...}: {
  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true; # Falls XWayland im Einsatz ist
    name = "Bibata-Modern-Classic";
    size = 24;
    package = pkgs.bibata-cursors;
  };
}
