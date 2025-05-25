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
      terminal = "${lib.getExe pkgs.alacritty}";
      startup = [
        { command = "alacritty"; }
      ];
    };
  };

  programs = {
    firefox.enable = true;
  };
}
