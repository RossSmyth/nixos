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
      modifier = "Mod4";
      terminal = "${lib.getExe pkgs.alacritty}";
      startup = [
        { command = "${lib.getExe pkgs.alacritty}"; }
      ];
    };
  };

  programs = {
    firefox.enable = true;
  };
}
