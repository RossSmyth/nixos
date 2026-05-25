{ pkgs, ... }:
{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  # Expose to the world
  services.caddy = {
    enable = true;

    package = pkgs.caddy.withPlugins {
      plugins = [
        "github.com/caddy-dns/cloudflare@v0.2.4"
      ];
      hash = "sha256-bzMqxWTqrJ1skZmRTXyEMCKStXpljbqe5r0Ve2cnBfM=";
    };

    virtualHosts."192.168.1.11".extraConfig = ''
      reverse_proxy :8096
      tls internal
    '';

    virtualHosts."jellyfin.rsmyth.net".extraConfig = ''
      tls {
        dns cloudflare {env.CF_API_TOKEN}
        resolvers 1.1.1.1
      }  
      reverse_proxy :8096
    '';
  };

  networking.firewall = {
    allowedTCPPorts = [
      80
      443
    ];
  };

  # For local tls
  systemd.services.caddy.path = [
    pkgs.nss.tools
  ];

  # temporary, to use a secret manager
  systemd.services.caddy.serviceConfig.EnvironmentFile = [
    "/etc/secrets/caddy.env"
  ];
}
