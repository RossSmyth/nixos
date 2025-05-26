{ config, ... }:
{
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
}
