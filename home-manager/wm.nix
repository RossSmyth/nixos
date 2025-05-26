{ pkgs, lib, ... }:
{
  # Needed for wayland
  home.packages = with pkgs; [
    wl-clipboard-rs
  ];

  # Notification daemon
  services.mako.enable = true;

  # Secrets
  services.gnome-keyring.enable = true;

  # WM
  wayland.windowManager.sway = {
    enable = true;
    checkConfig = true;
    wrapperFeatures.gtk = true;
    config = {
      # With inconsolata the default is small
      fonts = {
        size = 13.0;
      };
      workspaceLayout = "tabbed";

      # For some reason the default is Alt
      modifier = "Mod4";

      # IDK
      terminal = "${lib.getExe pkgs.alacritty}";

      # Maybe remove firefox?
      startup = [
        { command = "${lib.getExe pkgs.alacritty}"; }
        { command = "firefox"; }
      ];
    };
  };
}
