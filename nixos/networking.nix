{ hostname, pkgs, ... }:
{
  networking = {
    networkmanager.enable = true;
    hostName = hostname;
  };

  hardware.bluetooth.enable = true;
  environment.defaultPackages = with pkgs; [
    bluetui
  ];
}
