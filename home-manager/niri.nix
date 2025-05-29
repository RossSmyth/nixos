{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
{
  imports = [
    inputs.niri.homeModules.niri
    ./niri-config.nix
  ];

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

  programs.niri = {
    package = pkgs.niri;
    enable = true;
  };

  programs.waybar.enable = true;
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = lib.getExe pkgs.alacritty;
      };
    };
  };
}
