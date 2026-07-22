{ config, lib, ... }:
let
  cfg = config.services.navidrome;
in
{
  imports = [
    ./restic.nix
    ./agenix.nix
  ];

  # Expose to the world
  # Need to be in the same group for UDS perms
  users.users.navidrome.extraGroups = lib.mkIf config.services.lidarr.enable [
    config.services.lidarr.group
  ];

  services.navidrome = {
    enable = true;

    settings = {
      Agents = "listenbrainz";
      AlbumPlayCountMode = "normalized";
      DefaultShareExpiration = "24h";
      SessionTimeout = "10h";
      ShareURL = "https://music.rsmyth.net";
      UIWelcomeMessage = ":3c";
      MusicFolder = "/media/lib/music";

      # NOTE: This is within the `pivot_root` of the server, as Navidrome is the one that creates
      # the socket. So in reality this is "${systemd.services.navidrome.RootDirectory}/server.socket"
      # Which should be "/run/navidrome/server.socket"
      Address = "unix:/server.socket";
      UnixSocketPerm = "0660";

      # We will manage our own backups with downtime.
      Backup.Count = 0;
    };
  };

  # https://www.navidrome.org/docs/usage/configuration/options/#opt-passwordencryptionkey
  # TODO: Set this with some passphrase & agenix
  # ND_PASSWORDENCRYPTIONKEY="aaaaaaaaaaaaaa"
  #
  # systemd.services.navidrome.serviceConfig.EnvironmentFile = ...;

  rsmyth.backups.services.navidrome = {
    pathsInclude = [
      cfg.WorkingDirectory
    ];
    pathsExclude = [
      cfg.CacheFolder
    ];
    preBackupScript = ''
      systemctl stop navidrome.service
    '';
    postBackupScript = ''
      systemctl start navidrome.service
    '';
  };

  services.caddy.virtualHosts."music.rsmyth.net" = {
    extraConfig = ''
      tls {
        dns cloudflare {env.CF_API_TOKEN}
        resolvers 1.1.1.1
      }
      reverse_proxy ${config.systemd.navidrome.RootDirectory}/server.socket
    '';
  };
}
