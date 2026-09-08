{ config, lib, ... }:
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
      # My router IPv6 DNS setup is dumb,
      # so I cannot reliably make it work
      # and it breaks my local nameres.
      ipv6AcceptRAConfig.UseDNS = false;
      dhcpV6Config.UseDNS = false;
    };
  };

  # For some reason resolved saw my DHCP-provided DNS,
  # and then ignored it and used its builtin fallbacks.
  # This broke local nameres I have setup.
  #
  # Disable so local resolution doesn't break
  services.resolved.settings.Resolve = {
    MulticastDNS = true;
  };
}
