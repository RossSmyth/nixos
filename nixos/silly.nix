{
  # No need for backup as all the data is on GH
  # I guess it could be in the store, but it's a private
  # repo for now so shrug
  services.caddy.virtualHosts."dynasty-scams.com".extraConfig = ''
    redir /premium /premium/

    handle_path /premium* {
      root * /var/www/dynasty
      file_server
    }

    handle {
      redir https://dynasty-scans.com{uri} permanent
    }
  '';
}
