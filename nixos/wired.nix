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

  # For some reason resolved saw my DHCP-provided DNS,
  # and then ignored it and used its builtin fallbacks.
  # This broke local nameres I have setup.
  #
  # Disable so local resolution doesn't break
  services.resolved.settings.Resolve = {
    FallbackDNS = [ ];
    MulticastDNS = true;
  };
}
