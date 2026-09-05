{
  imports = [
    ./networking.nix
  ];

  # We need something to supply resolv.conf.
  # nm isn't doing it.
  services.resolved.enable = true;

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
