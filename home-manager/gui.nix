{ pkgs, ... }:
# Common config for (GUI) desktop computers
{
  xdg = {
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      configPackages = [
        pkgs.xdg-desktop-portal-wlr
        pkgs.xdg-desktop-portal-gtk
      ];
      extraPortals = [
        pkgs.xdg-desktop-portal-wlr
        pkgs.xdg-desktop-portal-gtk
      ];
    };
    enable = true;
  };
  programs = {
    firefox.enable = true;

    # TUI Spotify
    spotify-player.enable = true;

    # TODO: Add mpv config
    mpv.enable = true;

  };
}
