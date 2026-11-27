{ pkgs, ... }:
{
  systemd.user.services = {
    lucy-desktop = {
      Unit = {
        Description = "Lucy Desktop (private WayVNC socket)";
        PartOf = [ "graphical-session.target" ];
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };
      Service = {
        RuntimeDirectory = "lucy-desktop";
        RuntimeDirectoryMode = "0700";
        ExecStart = "${pkgs.wayvnc}/bin/wayvnc --config /dev/null --unix-socket %t/lucy-desktop/rfb.sock";
        Restart = "on-failure";
        RestartSec = 3;
      };
    };
    lucy-desktop-tailnet = {
      Unit = {
        Description = "Lucy Desktop (server01 only over Tailscale)";
        PartOf = [ "graphical-session.target" ];
        BindsTo = [ "lucy-desktop.service" ];
        After = [ "lucy-desktop.service" ];
        StartLimitIntervalSec = 0;
      };
      Service = {
        # Keep Tailscale's default anti-spoofing/netfilter enabled. No wildcard
        # listener, LAN firewall opening, SSH server, or privilege grant.
        ExecStart = "${pkgs.socat}/bin/socat TCP4-LISTEN:5901,bind=100.67.81.38,range=100.81.201.101/32,reuseaddr,fork UNIX-CONNECT:%t/lucy-desktop/rfb.sock";
        Restart = "on-failure";
        RestartSec = 5;
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}