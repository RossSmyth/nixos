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

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Enable sound.
  services.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Half-decent TTY font
  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.pdf.gz";

  # GPU Stuff
  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement.finegrained = true;

    open = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  system.stateVersion = "24.05"; # Did you read the comment?

}
