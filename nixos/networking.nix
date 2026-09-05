{ pkgs, ... }: {

  # We need something to supply resolv.conf.
  # nm isn't doing it.
  services.resolved.enable = true;

  hardware.bluetooth.enable = true;
  environment.defaultPackages = with pkgs; [
    bluetui
  ];
}
