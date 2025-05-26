_: {
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Login automatically on the TTY on start
  services.getty = {
    autologinUser = "rsmyth";
    autologinOnce = true;
  };
}
