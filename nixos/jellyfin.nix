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
    tags = [ "jellyfin" ];
    pathsInclude = [
      "/var/lib/jellyfin"
    ];
    preBackupScript = ''
      systemctl stop jellyfin
    '';
    postBackupScript = ''
      systemctl start jellyfin
    '';
  };

  # Expose to the world
  services.caddy = {
    # For accessing internally on my LAN
    virtualHosts."192.168.1.11".extraConfig = ''
      tls internal
      reverse_proxy :8096
    '';

    # For external users
    virtualHosts."jellyfin.rsmyth.net" = {
      extraConfig = ''
        tls {
          dns cloudflare {env.CF_API_TOKEN}
          resolvers 1.1.1.1
        }
        reverse_proxy :8096
      '';
    };
  };
}
