{
  imports = [
    ./networking.nix
  ];

  networking.networkmanager = {
    enable = true;
    # Put mutable state into /var
    settings.keyfile.path = "/var/lib/NetworkManager/system-connections";
  };
}
