{ config, ... }:
{
  # GPU Stuff
  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.finegrained = true;
    prime.offload = {
      enableOffloadCmd = true;
      enable = true;
    };

    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
