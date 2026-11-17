{ pkgs, ... }:

{
  # 1. GTK3 & GTK4 Dark Mode
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "breeze-dark";
      package = pkgs.kdePackages.breeze-icons;
    };
  };

  # 2. Modernes Dark-Mode-Signal für libadwaita, Firefox & Portale
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  # 3. Qt-Theming einheitlich aktivieren
  qt = {
    enable = true;
    platformTheme.name = "kde";
    style.name = "breeze";
  };
}
