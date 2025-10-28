{
  lib,
  pkgs,
  config,
  ...
}:
{
  # MPRIS daemon
  services.playerctld.enable = true;

  # Status bar
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ./waybar.css;

    settings.mainBar = {
      height = 25;
      spacing = 2;
      modules-left = [
        "niri/workspaces"
      ];
      modules-center = [
        "mpris"
      ];
      modules-right = [
        "idle_inhibitor"
        "pulseaudio"
        "network"
        "cpu"
        "memory"
        "temperature"
        "battery"
        "clock"
        "tray"
        "custom/power"
      ];
      mpris = {
        format = "{status_icon} | {dynamic}";
        dynamic-order = [
          "position"
          "title"
          "artist"
          "album"
        ];
        status-icons = {
          paused = "⏸";
          playing = "▶";
          stopped = "⏹";
        };
        ignored-players = [ "firefox" ];
      };
      idle_inhibitor = {
        format = "{icon}";
        format-icons = {
          activated = "";
          deactivated = "";
        };
      };
      tray.spacing = 10;
      clock.format-alt = "{:%Y-%m-%d}";
      memory.format = "{}% ";
      temperature = {
        hwmon-path-abs = "/sys/devices/platform/coretemp.0/hwmon";
        input-filename = "temp1_input";
        critical-threshold = 80;
        format = "{temperatureC}°C {icon}";
        format-icons = [
          ""
          ""
          ""
        ];
      };
      battery = {
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{capacity}% {icon}";
        format-full = "{capacity}% {icon}";
        format-charging = "{capacity}% ";
        format-plugged = "{capacity}% ";
        format-alt = "{time} {icon}";
        format-icons = [
          ""
          ""
          ""
          ""
          ""
        ];
      };
      network = {
        format-wifi = "{essid} ({signalStrength}%) ";
        format-ethernet = "{ipaddr}/{cidr} ";
        tooltip-format = "{ifname} via {gwaddr} ";
        format-linked = "{ifname} (No IP) ";
        format-disconnected = "Disconnected ⚠";
        on-click = "${lib.getExe config.programs.ghostty.package} -e nmtui";
      };
      pulseaudio = {
        format = "{volume}% {icon} {format_source}";
        format-bluetooth = "{volume}% {icon} {format_source}";
        format-bluetooth-muted = " {icon} {format_source}";
        format-muted = " {format_source}";
        format-source = "{volume}% ";
        format-source-muted = "";
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = [
            ""
            ""
            ""
          ];
        };
        on-click = "${lib.getExe config.programs.ghostty.package} -e ${lib.getExe pkgs.wiremix}";
      };
      "custom/logout" = {
        format = "⏻ ";
        tooltip = false;
        on-click = "shutdown now";
      };
    };
  };
}
