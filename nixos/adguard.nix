{
  services.adguardhome = {
    enable = true;
    mutableSettings = false;
    settings = {
      filtering.rewrites = [
        {
          domain = "*.rsmyth.net";
          answer = "192.168.1.12";
          enabled = true;
        }
      ];
      dns = {
        bootstrap_prefer_ipv6 = true;
        bootstrap_dns = [
          # Quad9
          "2620:fe::10"
          "2620:fe::fe:10"
          "9.9.9.10"
          "149.112.112.10"
        ];
        fallback_dns = [
          # Cloudflare
          "2606:4700:4700::1111"
          "2606:4700:4700::1001"
          "1.1.1.1"
          "1.0.0.1"
        ];
      };
    };
  };
}
