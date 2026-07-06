{ lib, pkgs, ... }:
{
  services.udev.packages = [
    pkgs.oversteer
  ];

  environment.systemPackages = [
    pkgs.oversteer
  ];

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c261", RUN+="${lib.getExe pkgs.usb-modeswitch} -v 046d -p c261 -m 01 -r 01 -C 03 -M '0f00010142'"
  '';

  hardware.new-lg4ff.enable = true;
}
