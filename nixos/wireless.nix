{
  imports = [
    ./networking.nix
  ];

  networking.useDHCP = true;
  networking.networkmanager = {
    enable = true;
    # Put mutable state into /var
    settings.keyfile.path = "/var/lib/NetworkManager/system-connections";
  };
}
