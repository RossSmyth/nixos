{
  lib,
  pkgs,
  user,
  ...
}:
{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot = lib.mkIf (!pkgs.stdenv.hostPlatform.isRiscV) {
    enable = true;
    editor = false;
    # enables the bootloader to count the numberof failed boots before dropping us in an emergecy shell
    bootCounting.enable = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # Hold space to access the boot menu
  boot.loader.timeout = 0;

  # Use systemd in initrd
  boot.initrd.systemd.enable = true;

  # No perl messing with my /etc
  system.etc.overlay.enable = true;

  # do stage2 init with nixos-init, a rust executable,
  # instead of a funny perl script
  system.nixos-init.enable = true;

  # Login automatically on the TTY on start
  services.getty = {
    autologinUser = user;
    autologinOnce = true;
  };
}
