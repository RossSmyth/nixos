{ lib, config, ... }:
{
  # GPU Stuff
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    open = lib.mkDefault true;
    package = lib.mkDefault config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
