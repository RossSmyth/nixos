{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    wl-clipboard-rs
  ];

  # Notification daemon
  services.mako = {
    enable = true;
    settings.default-timeout = 5;
  };

  # Launcher
  programs.fuzzel = {
    enable = true;
    settings.main.terminal = lib.getExe config.programs.ghostty.package;
  };

  # Lock screen
  programs.swaylock = {
    enable = true;
    settings = {
      color = "#FFFFFF";
      image = "${./bg.jpg}";
      scaling = "fit";
    };
  };

  programs.niri.settings.xwayland-satellite.enable = true;
  programs.niri.settings.xwayland-satellite.path =
    lib.getExe
      inputs.niri.packages.${pkgs.stdenv.system}.xwayland-satellite-unstable;

  programs.niri.settings = {
    input.mouse = {
      accel-speed = 0;
      accel-profile = "flat";
    };
    spawn-at-startup = [
      { command = [ "mako" ]; }
      {
        command = [
          (lib.getExe pkgs.swaybg)
          "-c"
          "#FFFFFF"
          "-o"
          "*"
          "-m"
          "fit"
          "-i"
          "${./bg.jpg}"
        ];
      }
      { command = [ "ghostty" ]; }
    ];
    binds = with config.lib.niri.actions; {
      # apps
      "Mod+Return".action.spawn = "ghostty";
      "Mod+B".action.spawn = "firefox";
      "Mod+D".action.spawn = "fuzzel";
      # session
      "Mod+Alt+P".action.spawn = "poweroff";
      "Mod+Alt+R".action.spawn = "reboot";
      "Mod+Alt+Q".action = quit;
      "Mod+Shift+Space".action.spawn = [
        "swaylock"
        "-Ffe"
      ];
      # workspaces
      "Mod+Space".action = toggle-overview;
      "Mod+1".action.focus-workspace = 1;
      "Mod+2".action.focus-workspace = 2;
      "Mod+3".action.focus-workspace = 3;
      "Mod+4".action.focus-workspace = 4;
      "Mod+5".action.focus-workspace = 5;
      "Mod+6".action.focus-workspace = 6;
      "Mod+7".action.focus-workspace = 7;
      "Mod+8".action.focus-workspace = 8;
      "Mod+9".action.focus-workspace = 9;
      "Mod+Shift+1".action.move-column-to-workspace = 1;
      "Mod+Shift+2".action.move-column-to-workspace = 2;
      "Mod+Shift+3".action.move-column-to-workspace = 3;
      "Mod+Shift+4".action.move-column-to-workspace = 4;
      "Mod+Shift+5".action.move-column-to-workspace = 5;
      "Mod+Shift+6".action.move-column-to-workspace = 6;
      "Mod+Shift+7".action.move-column-to-workspace = 7;
      "Mod+Shift+8".action.move-column-to-workspace = 8;
      "Mod+Shift+9".action.move-column-to-workspace = 9;
      # sizing
      "Mod+F".action = maximize-column;
      "Mod+Shift+F".action = fullscreen-window;
      "Mod+Q".action = close-window;
      "Mod+C".action = center-column;
      "Mod+Shift+W".action = switch-preset-column-width;
      "Mod+Minus".action.set-column-width = "-10%";
      "Mod+Equal".action.set-column-width = "+10%";
      # move and focus
      # Try to move by-column, and focus by window. Then make
      # it work with monitor and workspaces mostly seamlessly.
      #
      # I don't currently have any monitors up or down so that's
      # not really accounted for.
      ## Left
      "Mod+WheelScrollUp".action = focus-column-left-or-last;
      "Mod+H".action = focus-column-or-monitor-left;
      "Mod+Shift+H".action = move-column-left;
      "Mod+Alt+H".action = move-column-to-monitor-left;
      ## Right
      "Mod+WheelScrollDown".action = focus-column-right-or-first;
      "Mod+L".action = focus-column-or-monitor-right;
      "Mod+Shift+L".action = move-column-right;
      "Mod+Alt+L".action = move-column-to-monitor-right;
      ## Up
      "Mod+K".action = focus-window-or-workspace-up;
      "Mod+Shift+K".action = move-column-to-workspace-up;
      ## Down
      "Mod+J".action = focus-window-or-workspace-down;
      "Mod+Shift+J".action = move-column-to-workspace-down;
      # float
      "Mod+V".action = toggle-window-floating;
      "Mod+Shift+V".action = switch-focus-between-floating-and-tiling;
      # Window consume/expel to columns
      "Mod+Ctrl+H".action = consume-or-expel-window-left;
      "Mod+Ctrl+L".action = consume-or-expel-window-right;
      # screenshots
      "Print".action.screenshot = { };
      "Shift+Print".action.screenshot-screen = { };
      # fn
      "XF86AudioRaiseVolume".action.spawn = [
        "wpctl"
        "set-volume"
        "@DEFAULT_AUDIO_SINK@"
        "0.1+"
      ];
      "XF86AudioLowerVolume".action.spawn = [
        "wpctl"
        "set-volume"
        "@DEFAULT_AUDIO_SINK@"
        "0.1-"
      ];
      "XF86AudioMute".action.spawn = [
        "wpctl"
        "set-mute"
        "@DEFAULT_AUDIO_SINK@"
        "toggle"
      ];
      "XF86AudioPlay".action.spawn = [
        "playerctl"
        "play-pause"
      ];
      "XF86AudioNext".action.spawn = [
        "playerctl"
        "next"
      ];
      "XF86AudioPrev".action.spawn = [
        "playerctl"
        "previous"
      ];
      "XF86MonBrightnessDown".action.spawn = [
        "brightnessctl"
        "s"
        "5%-"
      ];
      "XF86MonBrightnessUp".action.spawn = [
        "brightnessctl"
        "s"
        "+5%"
      ];
      "Mod+Shift+Slash".action = show-hotkey-overlay;
    };
    hotkey-overlay.skip-at-startup = true;
  };
}
