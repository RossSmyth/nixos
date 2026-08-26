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
    hackneyed
  ];

  # Notification daemon
  services.mako = {
    enable = true;
    settings.default-timeout = 5;
  };

  # Launcher
  programs.rofi = {
    enable = true;
    terminal = lib.getExe config.programs.ghostty.package;
    modes = [
      "drun"
    ];
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

  wayland.windowManager.niri = {
    enable = true;
    package = pkgs.niri;
    settings = {
      cursor = {
        xcursor-theme = "Hackneyed";
        xcursor-size = 24;
      };
      gestures.hot-corners.off = { };
      input = {
        keyboard = {
          xkb = {
            layout = "";
            model = "";
            rules = "";
            variant = "";
          };
          repeat-delay = 600;
          repeat-rate = 25;
          track-layout = "global";
        };
        touchpad = {
          tap = { };
          natural-scroll = { };
        };
        mouse = {
          accel-speed = 0;
          accel-profile = "flat";
        };
      };
      screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";
      layout = {
        gaps = 16;
        struts = {
          left = 0;
          right = 0;
          top = 0;
          bottom = 0;
        };
        focus-ring.width = 4;
        border.off = { };
        default-column-width = { };
        center-focused-column = "never";
      };
      _children = [
        { spawn-at-startup = [ "mako" ]; }
        {
          spawn-at-startup = [
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
        { spawn-at-startup = [ "ghostty" ]; }
        {
          output = {
            _args = [ "LG Electronics LG HDR WFHD 0x0003593A" ];
            transform = "normal";
            mode = "2560x1080@74.991000";
            variable-refresh-rate._props."on-demand" = false;
          };
        }
        {
          output = {
            _args = [ "LG Electronics LG ULTRAWIDE 0x0007E9D3" ];
            transform = "normal";
            mode = "2560x1080@74.991000";
            variable-refresh-rate._props."on-demand" = false;
          };
        }
      ];
      binds = {
        # apps
        "Mod+Return".spawn = "ghostty";
        "Mod+B".spawn = "firefox";
        "Mod+D".spawn = [
          "rofi"
          "-show"
          "drun"
        ];
        "Mod+E".spawn = [
          (lib.getExe pkgs.rofimoji)
        ];
        # session
        "Mod+Alt+P".spawn = "poweroff";
        "Mod+Alt+R".spawn = "reboot";
        "Mod+Alt+Q".quit = { };
        "Mod+Shift+Space".spawn = [
          "swaylock"
          "-Ffe"
        ];
        # workspaces
        "Mod+Space".toggle-overview = { };
        "Mod+1".focus-workspace = 1;
        "Mod+2".focus-workspace = 2;
        "Mod+3".focus-workspace = 3;
        "Mod+4".focus-workspace = 4;
        "Mod+5".focus-workspace = 5;
        "Mod+6".focus-workspace = 6;
        "Mod+7".focus-workspace = 7;
        "Mod+8".focus-workspace = 8;
        "Mod+9".focus-workspace = 9;
        "Mod+Shift+1".move-column-to-workspace = 1;
        "Mod+Shift+2".move-column-to-workspace = 2;
        "Mod+Shift+3".move-column-to-workspace = 3;
        "Mod+Shift+4".move-column-to-workspace = 4;
        "Mod+Shift+5".move-column-to-workspace = 5;
        "Mod+Shift+6".move-column-to-workspace = 6;
        "Mod+Shift+7".move-column-to-workspace = 7;
        "Mod+Shift+8".move-column-to-workspace = 8;
        "Mod+Shift+9".move-column-to-workspace = 9;
        # sizing
        "Mod+F".maximize-column = { };
        "Mod+Shift+F".fullscreen-window = { };
        "Mod+Q".close-window = { };
        "Mod+C".center-column = { };
        "Mod+Shift+W".switch-preset-column-width = { };
        "Mod+Minus".set-column-width = "-10%";
        "Mod+Equal".set-column-width = "+10%";
        # move and focus
        # Try to move by-column, and focus by window. Then make
        # it work with monitor and workspaces mostly seamlessly.
        #
        # I don't currently have any monitors up or down so that's
        # not really accounted for.
        ## Left
        "Mod+WheelScrollUp".focus-column-left-or-last = { };
        "Mod+H".focus-column-or-monitor-left = { };
        "Mod+Shift+H".move-column-left = { };
        "Mod+Alt+H".move-column-to-monitor-left = { };
        ## Right
        "Mod+WheelScrollDown".focus-column-right-or-first = { };
        "Mod+L".focus-column-or-monitor-right = { };
        "Mod+Shift+L".move-column-right = { };
        "Mod+Alt+L".move-column-to-monitor-right = { };
        ## Up
        "Mod+K".focus-window-or-workspace-up = { };
        "Mod+Shift+K".move-column-to-workspace-up = { };
        ## Down
        "Mod+J".focus-window-or-workspace-down = { };
        "Mod+Shift+J".move-column-to-workspace-down = { };
        # float
        "Mod+V".toggle-window-floating = { };
        "Mod+Shift+V".switch-focus-between-floating-and-tiling = { };
        # Window consume/expel to columns
        "Mod+Ctrl+H".consume-or-expel-window-left = { };
        "Mod+Ctrl+L".consume-or-expel-window-right = { };
        # screenshots
        "Print".screenshot = { };
        "Shift+Print".screenshot-screen = { };
        # fn
        "XF86AudioRaiseVolume".spawn = [
          "wpctl"
          "set-volume"
          "@DEFAULT_AUDIO_SINK@"
          "0.1+"
        ];
        "XF86AudioLowerVolume".spawn = [
          "wpctl"
          "set-volume"
          "@DEFAULT_AUDIO_SINK@"
          "0.1-"
        ];
        "XF86AudioMute".spawn = [
          "wpctl"
          "set-mute"
          "@DEFAULT_AUDIO_SINK@"
          "toggle"
        ];
        "XF86AudioPlay".spawn = [
          "playerctl"
          "play-pause"
        ];
        "XF86AudioNext".spawn = [
          "playerctl"
          "next"
        ];
        "XF86AudioPrev".spawn = [
          "playerctl"
          "previous"
        ];
        "XF86MonBrightnessDown".spawn = [
          "brightnessctl"
          "s"
          "5%-"
        ];
        "XF86MonBrightnessUp".spawn = [
          "brightnessctl"
          "s"
          "+5%"
        ];
        "Mod+Shift+Slash".show-hotkey-overlay = { };
      };
      hotkey-overlay.skip-at-startup = true;
    };
  };
}
