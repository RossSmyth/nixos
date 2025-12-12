{
  imports = [
    ./nix.nix
    ./shell.nix
    ./security.nix
    ./networking.nix
    ./users.nix
    ./coreutils.nix
  ];

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/Detroit";
  systemd.coredump.enable = true;
  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  # Useful userspace oom killer
  systemd.oomd = {
    enableRootSlice = true;
    enableUserSlices = true;
  };

  # Disable things I will never use
  documentation = {
    info.enable = false;
    nixos.enable = false;
  };

  # So I can have disks mounted when plugged in
  services.udisks2.enable = true;

  # Stop suspending all my stuff every few seconds :(
  services.tlp = {
    enable = true;
    settings = {
      USB_AUTOSUSPEND = 0;
      SOUND_POWER_SAVE_ON_AC = 0;
      SOUND_POWER_SAVE_ON_BAT = 0;
    };
  };

  system.stateVersion = "24.05";
}
