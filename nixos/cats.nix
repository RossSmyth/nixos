{
  imports = [
    ./restic.nix
  ];

  rsmyth.backups.services.cats = {
    pathsInclude = [
      "/var/www/cats"
    ];
  };

  services.caddy.virtualHosts."cats.rsmyth.net" = {
    logFormat = ''
      output stdout
      format console
    '';
    extraConfig = ''
      tls {
        dns cloudflare {env.CF_API_TOKEN}
        resolvers 1.1.1.1
      }
      root /var/www/cats
      file_server
    '';
  };
}
