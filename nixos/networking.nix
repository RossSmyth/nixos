{ pkgs, ... }: {
  hardware.bluetooth.enable = true;
  environment.defaultPackages = with pkgs; [
    bluetui
  ];
}
