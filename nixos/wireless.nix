{
  imports = [
    ./networking.nix
  ];
  # I don't use this, and it breaks immutable etc
  networking.wireless = {
    allowAuxiliaryImperativeNetworks = false;
    userControlled = true;
  };
  networking.networkmanager = {
    enable = true;
    # Put mutable state into /var
    settings.keyfile.path = "/var/lib/NetworkManager/system-connections";
  };
}
