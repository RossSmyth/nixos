{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  wayland.windowManager.sway = {
    enable = true;
    checkConfig = true;
    config = {
      terminal = "${lib.getExe pkgs.alacritty}";
    };
  };
}
