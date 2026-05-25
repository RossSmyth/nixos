{pkgs, ... }: {
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
    
    globalConfig = ''
        tls {
          dns cloudflare {env.CF_API_TOKEN}
        }  
      '';
    virtualHosts."jellyfin.rsmyth.net".extraConfig = ''
      reverse_proxy :8096
    '';
  };

  # temporary, to use a secret manager
  systemd.services.caddy.serviceConfig.EnvironmentFile = [
    "/etc/secrets/caddy.env"
  ];
}
