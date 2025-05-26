{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  services.gnome-keyring.enable = true;
  wayland.windowManager.sway = {
    enable = true;
    checkConfig = true;
    wrapperFeatures.gtk = true;
    config = {
      workspaceLayout = "tabbed";
      modifier = "Mod4";
      terminal = "${lib.getExe pkgs.alacritty}";
      startup = [
        { command = "${lib.getExe pkgs.alacritty}"; }
        { command = "firefox"; }
      ];
    };
  };

  xdg.enable = true;
  programs = {
    firefox.enable = true;
    spotify-player.enable = true;

    # TODO: Add mpv config
    mpv.enable = true;
  };
}
