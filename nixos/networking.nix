{ hostname, pkgs, ... }:
{
  networking = {
    networkmanager.enable = true;
    hostName = hostname;
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];

    hosts = {
      "192.168.1.12" = [ "jammy.home" ];
      "192.168.1.11" = [ "trent.home" ];
      "192.168.1.10" = [ "desktop.home" ];
    };
  };

  hardware.bluetooth.enable = true;
  environment.defaultPackages = with pkgs; [
    bluetui
  ];
}
