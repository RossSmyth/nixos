{ pkgs, config, ... }:
{
  imports = [
    ./restic.nix
  ];
  # Machine-specific hardware options can be set as well.
  services.jellyfin.enable = true;

  # Do a full stop for backups rather than using the built-in backup
  # 1. Don't need to use an API token even though it's on the same machine
  # 2. Deduplication accross backups
  rsmyth.backups.services.jellyfin = {
    pathsInclude = [
      "/var/lib/jellyfin"
    ];
    preBackupScript = ''
      systemctl stop jellyfin.service
    '';
    postBackupScript = ''
      systemctl start jellyfin.service
    '';
  };

  # Expose to the world
  services.caddy.virtualHosts."jellyfin.rsmyth.net".extraConfig = ''
    reverse_proxy :8096
  '';
}
