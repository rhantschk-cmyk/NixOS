{ pkgs, ... }:
let
  mcMojaveSddmTheme = pkgs.stdenvNoCC.mkDerivation {
    pname = "mcmojave-sddm-theme";
    version = "a1745e9c35d57c6db7e298180dba53ac4a70fee9";

    src = pkgs.fetchFromGitHub {
      owner = "vinceliuice";
      repo = "McMojave-kde";
      rev = "a1745e9c35d57c6db7e298180dba53ac4a70fee9";
      hash = "sha256-4INopkfRe2g+FJRUW1DDVEP79O9TuLo3W5BSAmMTXSc=";
    };

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/share/sddm/themes"
      cp -r sddm/6.0/McMojave "$out/share/sddm/themes/"
      runHook postInstall
    '';
  };
in
{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;

    theme = "McMojave";

    settings = {
      General = {
        Numlock = "on";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    mcMojaveSddmTheme
    kdePackages.sddm-kcm
  ];
}
