{
  imports = [
    ./networking.nix
  ];

  networking.useDHCP = true;
  networking.networkmanager.enable = true;
}
