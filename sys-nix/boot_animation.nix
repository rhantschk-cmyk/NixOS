{ pkgs, ... }:

{
  boot = {
    plymouth = {
      enable = true;
      theme = "breeze";
    };

    # Text verstecken
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [ "quiet" "splash" "loglevel=3" "rd.systemd.show_status=false" ];
  };
}
