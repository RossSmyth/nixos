{ pkgs, lib, ... }:
{

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        size = 13;
        bold_italic.family = "Inconsolata Nerd Font Mono";
        bold.family = "Inconsolata Nerd Font Mono";
        italic.family = "Inconsolata Nerd Font Mono";
        normal.family = "Inconsolata Nerd Font Mono";
      };
    };
  };
}
