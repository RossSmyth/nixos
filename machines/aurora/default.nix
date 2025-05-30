{
  imports = [
    ./hardware-configuration.nix
  ];

  hardware.nvidia.prime = {
    intelBusId = "00:02.0";
    nvidiaBusId = "01:00.0";
  };
}
