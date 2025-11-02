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
      intelBusId = "PCI:0@0:2:0";
      nvidiaBusId = "PCI:1@0:0:0";
    };
  };
}
