{ lib, config, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];
  networking.hostId = "8425e349";
}
