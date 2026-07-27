{
  pkgs,
  ...
}:
{
  programs = {
    firefox.enable = true;

    # TUI Spotify
    spotify-player.enable = true;
  };
  home.packages = [
    pkgs.feishin
  ];
}
