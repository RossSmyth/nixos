{ pkgs, lib, ... }: {

  # We need something to supply resolv.conf.
  # nm isn't doing it.
  services.resolved = {
    enable = true;
    settings.Resolve = {
      LLMNR = false;
      # Default to false to reduce attack area.
      # But will be enabled for wired connections.
      MulticastDNS = lib.mkDefault false;
    };
  };

  hardware.bluetooth.enable = true;
  environment.defaultPackages = with pkgs; [
    bluetui
  ];
}
