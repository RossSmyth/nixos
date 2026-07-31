{ config, hostname, ... }:
let
  cfg = config.services.adguardhome;
in
{
  # Don't open the web server ports
  networking.firewall = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };

  services.adguardhome = {
    enable = true;
    mutableSettings = false;
    host = "127.0.0.1";
    settings = {
      filters = [
        {
          name = "Hagezi DNS PRO";
          enabled = true;
          url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/pro.txt";
          id = 1;
        }
      ];
      filtering.rewrites = [
        {
          domain = "*.rsmyth.net";
          answer = "192.168.1.12";
          enabled = true;
        }
        {
          domain = "jammy.home";
          answer = "192.168.1.12";
          enabled = true;
        }
        {
          domain = "*.jammy.home";
          answer = "192.168.1.12";
          enabled = true;
        }
        {
          domain = "trent.home";
          answer = "192.168.1.11";
          enabled = true;
        }
        {
          domain = "*.trent.home";
          answer = "192.168.1.11";
          enabled = true;
        }
        {
          domain = "desktop.home";
          answer = "192.168.1.10";
          enabled = true;
        }
        {
          domain = "*.desktop.home";
          answer = "192.168.1.10";
          enabled = true;
        }
      ];
      dns = {
        serve_http3 = true;
        use_http3_upstreams = true;
        upstream_dns = [
          "tls://dns10.quad9.net"
          "https://dns10.quad9.net/dns-query"
        ];
        bootstrap_prefer_ipv6 = true;
        bootstrap_dns = [
          # Quad9
          "2620:fe::10"
          "9.9.9.10"
          # Quad9 is down use CF
          "2606:4700:4700::1111"
          "1.1.1.1"
        ];
        fallback_dns = [
          "one.one.one.one"
          "dns.google"
        ];
      };
    };
  };

  services.caddy.virtualHosts."dns.${hostname}.home" = {
    extraConfig = ''
      tls internal
      reverse_proxy :${toString cfg.port}
    '';
  };
}
