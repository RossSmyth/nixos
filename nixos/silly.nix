{
  services.caddy.virtualHosts."dynasty-scams.com" = {
    logFormat = ''
      output stdout
      format console
    '';

    extraConfig = ''
      tls {
        dns cloudflare {env.CF_API_TOKEN}
        resolvers 1.1.1.1
      }

      redir /premium /premium/

      handle_path /premium* {
        root * /var/www/dynasty
        file_server
      }

      handle {
        redir https://dynasty-scans.com{uri} permanent
      }
    '';
  };
}
