# Common config for (GUI) desktop computers
{ pkgs, lib, ... }:
{
  xdg.enable = true;
  programs = {
    firefox.enable = true;

    # TUI Spotify
    spotify-player.enable = true;

    # TODO: Add mpv config
    mpv.enable = true;

  };
}
