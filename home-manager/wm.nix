{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Needed for wayland
  home.packages = with pkgs; [
    wl-clipboard-rs
  ];

  # Notification daemon
  services.mako = {
    enable = true;
    settings.default-timeout = 5;
  };

  # Secrets
  services.gnome-keyring.enable = true;

  # WM
  wayland.windowManager.sway = {
    enable = true;
    checkConfig = true;
    wrapperFeatures.gtk = true;
    config = {
      # With inconsolata the default is small
      fonts.size = 13.0;

      workspaceLayout = "tabbed";

      # For some reason the default is Alt
      modifier = "Mod4";

      # IDK
      terminal = "${lib.getExe config.programs.alacritty.package}";

      # Maybe remove firefox?
      startup = [
        { command = "${lib.getExe config.programs.alacritty.package}"; }
        { command = "firefox"; }
      ];
    };
  };

  # Launcher
  programs.bemenu.enable = true;
  wayland.windowManager.sway.config.menu = lib.getExe' config.programs.bemenu.package "bemenu-run";
}
