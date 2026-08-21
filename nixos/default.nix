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
    enableSystemSlice = true;
    enableUserSlices = true;

    # Logic:
    # Generally PSI doesn't immediatly get pinned to the
    # limit set. So this means it has spent a longer time
    # than that going up to the limit. So 5 seconds at the
    # limit should be long enough.
    settings.OOM.DefaultMemoryPressureDurationSec = 5;
  };

  # 80% is pretty high, I'll leave that for the root slice.
  systemd.slices.system.sliceConfig.ManagedOOMMemoryPressureLimit = "50%";

  # User limit should be relatively low since it is user-facing.
  # I may lower it to 20% at some point.
  systemd.slices.user.sliceConfig.ManagedOOMMemoryPressureLimit = "30%";

  # Use dbus-broker cause it's a bit better
  services.dbus.implementation = "broker";

  # Disable things I will never use
  documentation = {
    info.enable = false;
    nixos.enable = false;
  };

  # So I can have disks mounted when plugged in
  services.udisks2.enable = true;

  system.stateVersion = "24.05";
}
