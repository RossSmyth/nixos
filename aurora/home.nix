{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    wl-clipboard-rs
  ];

  fonts.fontconfig.enable = true;
  fonts.fontconfig.defaultFonts = {
    serif = [ "Noto Serif" ];
    sansSerif = [ "Noto Sans" ];
    monospace = [ "inconsolata" ];
  };

  services.mako.enable = true;
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
