{ ... }:

{
  boot = {
    plymouth = {
      enable = true;
      theme = "breeze";
    };

    # Text verstecken
    consoleLogLevel = 0;
    kernelParams = [ "quiet" "splash" "loglevel=3" "rd.systemd.show_status=false" ];
  };
}
