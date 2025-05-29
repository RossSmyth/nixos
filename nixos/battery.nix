{
  # For laptops attempting to save battery life
  powerManagement = {
    enable = true;
    powertop.enable = true;
    cpuFreqGovernor = "powersave";
  };
  services = {
    thermald.enable = true;
    power-profiles-daemon.enable = false;

    auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
        charger = {
          turbo = "auto";
        };
      };
    };
  };
}
