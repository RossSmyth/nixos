{
  # No need for backup as all the data is on GH
  # I guess it could be in the store, but it's a private
  # repo for now so shrug
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
