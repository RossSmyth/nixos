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
    settings = {
      keyfile.path = "/var/lib/NetworkManager/system-connections";
      connection = {
        # Always use systemd-resolved
        # I will override specific case when to listen to DHCP (at home)
        ipv4.ignore-auto-dns = true;
        ipv6.ignore-auto-dns = true;
      };
    };
  };
}
