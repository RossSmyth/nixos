{
  imports = [
    ./networking.nix
  ];

  # Specifiy indivudally.
  networking.useDHCP = false;

  systemd.network = {
    enable = true;
    networks."10-wan" = {
      # UHHHHHHHHH
      matchConfig.Type = "ether";
      networkConfig = {
        DHCP = "ipv4";
        IPv6AcceptRA = true;
      };
    };
  };
}
