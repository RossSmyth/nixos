{ lib, pkgs, ... }:
{
  # Launcher
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = lib.getExe pkgs.alacritty;
      };
    };
  };
}
