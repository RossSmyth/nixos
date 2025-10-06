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
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # Login automatically on the TTY on start
  services.getty = {
    autologinUser = user;
    autologinOnce = true;
  };
}
