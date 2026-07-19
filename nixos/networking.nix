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
      "192.168.1.12" = "jammy.local";
      "192.168.1.11" = "trent.local";
      "192.168.1.10" = "desktop.local";
    };
  };

  hardware.bluetooth.enable = true;
  environment.defaultPackages = with pkgs; [
    bluetui
  ];
}
