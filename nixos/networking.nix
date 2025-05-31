{ hostname, pkgs, ... }:
{
  networking = {
    networkmanager.enable = true;
    hostName = hostname;
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
  };

  hardware.bluetooth.enable = true;
  environment.defaultPackages = with pkgs; [
    bluetui
  ];
}
