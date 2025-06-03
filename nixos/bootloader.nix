{ user, ... }:
{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot = {
    enable = true;
    memtest86.enable = true;
    editor = false;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # Login automatically on the TTY on start
  services.getty = {
    autologinUser = user;
    autologinOnce = true;
  };
}
