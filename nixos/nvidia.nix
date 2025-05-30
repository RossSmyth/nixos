{ config, ... }:
{
  # GPU Stuff
  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.finegrained = true;
    enableOffloadCmd = true;
    prime.offload = {
      enable = true;
    };

    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
