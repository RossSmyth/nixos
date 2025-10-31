{
  imports = [
    ./hardware-configuration.nix
  ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.finegrained = true;
    prime.offload = {
      enableOffloadCmd = true;
      enable = true;
    };

    prime = {
      intelBusId = "00:02.0";
      nvidiaBusId = "01:00.0";
    };
  };
}
