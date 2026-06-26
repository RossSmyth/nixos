{ pkgs, config, ... }:
{
  services.jellyfin = {
    # machine specific hardware options
    enable = true;
    openFirewall = true;
  };

  # Expose to the world
  services.caddy = {
    enable = true;

    package = pkgs.caddy.withPlugins {
      # Need this for some reason.
      plugins = [
        "github.com/caddy-dns/cloudflare@v0.2.4"
      ];
      hash = "sha256-8yZDrejNKsaUnUaTUFYbarWNmxafqp2z2rWo+XRsxV8=";
    };

    # Just log for journald
    logFormat = ''
      output stdout
      format console
    '';

    # For accessing internally on my LAN
    virtualHosts."192.168.1.11".extraConfig = ''
      reverse_proxy :8096
      tls internal
    '';

    # For external users
    virtualHosts."jellyfin.rsmyth.net" = {
      logFormat = ''
        output stdout
        format console
      '';
      extraConfig = ''
        tls {
          dns cloudflare {env.CF_API_TOKEN}
          resolvers 1.1.1.1
        }
        reverse_proxy :8096
      '';
    };
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

  systemd.services.caddy.serviceConfig.EnvironmentFile = [
    config.age.secrets.caddy.path
  ];
}
