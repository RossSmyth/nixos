{
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
  #
  # Testing shows that while PSI is pinned at 20%, I can open firefox,
  # open a tab of the nixpkgs reference, and open a youtube tab and watch
  # a video and it's fine. So 30% it shall stay.
  systemd.slices.user.sliceConfig.ManagedOOMMemoryPressureLimit = "30%";
}
