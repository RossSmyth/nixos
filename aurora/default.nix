# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  security.sudo.enable = false;
  security.pam.services.systemd-run0 = {
    setEnvironment = true;
    pamMount = false;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Enable sound.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Login automatically
  services.displayManager.autoLogin.user = "rsmyth";
  services.getty.autologinUser = "rsmyth";

  console.font = "Lat2-Terminus16";
  fonts.packages = with pkgs; [
    nerd-fonts.inconsolata
    nerd-fonts.noto
    noto-fonts-emoji
  ];

  # Battery saving attempts
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

  # GPU Stuff
  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.finegrained = true;
    open = true;

    # For Optimus PRIME hybrid graphics
    prime = {
      intelBusId = "00:02.0";
      nvidiaBusId = "01:00.0";
    };

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  services.earlyoom = {
    enable = true;
    enableNotifications = true;
    freeSwapThreshold = 90;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${lib.getExe pkgs.greetd.tuigreet} --time --cmd ${lib.getExe pkgs.sway} ";
        user = "greeter";
      };
    };
  };

  system.stateVersion = "24.05"; # Did you read the comment?

}
