{
  imports = [
    ./restic.nix
  ];

  rsmyth.backups.services.cats = {
    pathsInclude = [
      "/var/www/cats"
    ];
  };

  services.caddy.virtualHosts."cats.rsmyth.net".extraConfig = ''
    root /var/www/cats
    file_server
  '';
}
