{ lib, config, ... }:
{
  # For laptops attempting to save battery life

  # Rule to disable all auto-suspend rules for HID devices
  services.udev.extraRules = ''
    ACTION=="add|bind", SUBSYSTEM=="input", TEST=="power/control", ATTR{power/control}="on"
  '';

  powerManagement = {
    enable = true;
    powertop = {
      enable = true;
      # Ensure HID devices are not suspended once powertop starts
      postStart = ''
        ${lib.getExe' config.systemd.package "udevadm"} trigger --action=bind --subsystem-match=input
      '';
    };
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
