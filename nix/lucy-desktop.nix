{ pkgs, ... }:
{
  # Local compatibility test only. Do not expose VNC until authentication and
  # server01-only access have been verified.
  systemd.user.services.lucy-desktop = {
    Unit = {
      Description = "Lucy Desktop (local Niri compatibility test)";
      PartOf = [ "graphical-session.target" ];
      ConditionEnvironment = "WAYLAND_DISPLAY";
    };
    Service = {
      ExecStart = "${pkgs.wayvnc}/bin/wayvnc --config /dev/null 127.0.0.1 5901";
      Restart = "on-failure";
      RestartSec = 3;
    };
    # No WantedBy: explicitly start for the local smoke test, not at login.
  };
}