{ pkgs, ... }:

let
  # 1. Das sddm-noctalia-theme direkt aus GitHub holen
  sddm-noctalia-theme = pkgs.stdenv.mkDerivation {
    name = "sddm-noctalia-theme";
    src = pkgs.fetchFromGitHub {
      owner = "ClementFombonne";
      repo = "sddm-noctalia-theme";
      rev = "main"; # Verwende einen festen Commit-Hash für 100% Reproduzierbarkeit
      sha256 = "sha256-crN2oqml/QJTjOCa3/i0MQREDvPzg5TYC5BfKnk77fQ="; # Mit echtem Hash ersetzen oder per 'nix-prefetch-url' holen
    };
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -r . $out/share/sddm/themes/sddm-noctalia-theme
    '';
  };
in
{
  # 2. SDDM aktivieren und das Noctalia-Theme setzen
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true; # Empfohlen, da Noctalia ein nativer Wayland-Workspace ist
    theme = "sddm-noctalia-theme";
    settings = {
      Theme = {
        CursorTheme = "Adwaita"; # Trage hier deinen Cursor-Namen ein
      };
    };
  };

  # 3. Das Theme zu den System-Packages hinzufügen, damit SDDM den Pfad findet
  environment.systemPackages = [
    sddm-noctalia-theme
    pkgs.adwaita-icon-theme
  ];

  # 4. Notwendige Qt6-Abhängigkeiten laden, da das Theme Qt6 voraussetzt
  services.displayManager.sddm.extraPackages = with pkgs.kdePackages; [
    qt5compat # Für Abwärtskompatibilität mancher QML-Komponenten
    qtdeclarative
    qtsvg
  ];
}

