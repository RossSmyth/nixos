{
  config,
  lib,
  hostname,
  ...
}:
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
      Agents = "listenbrainz,lastfm,deezer";
      AlbumPlayCountMode = "normalized";
      DefaultShareExpiration = "24h";
      SessionTimeout = "10h";
      ShareURL = "https://music.rsmyth.net";
      UIWelcomeMessage = ":3c";
      MusicFolder = "/media/lib/music";
      DataFolder = "/var/lib/navidrome";
      CacheFolder = "/var/lib/navidrome/cache";

      # NOTE: This is within the `pivot_root` of the server, as Navidrome is the one that creates
      # the socket. So in reality this is "${systemd.services.navidrome.RootDirectory}/server.socket"
      # Which should be "/run/navidrome/server.socket"
      Address = "unix:/server.socket";
      UnixSocketPerm = "0660";

      # We will manage our own backups with downtime.
      Backup.Count = 0;
    };
  };

  # ND_PASSWORDENCRYPTIONKEY
  age.secrets.navidrome = {
    file = ../secrets/navidrome.age;
    mode = "400";
    inherit (cfg) group;
    owner = cfg.user;
  };

  # https://www.navidrome.org/docs/usage/configuration/options/#opt-passwordencryptionkey
  systemd.services.navidrome.serviceConfig.EnvironmentFile = [
    config.age.secrets.navidrome.path
  ];
  systemd.services.navidrome.serviceConfig.WorkingDirectory = lib.mkForce "/";

  rsmyth.backups.services.navidrome = {
    # Include the music dir? For now, no.
    pathsInclude = [
      "/var/lib/navidrome"
    ];
    pathsExclude = [
      "/var/lib/navidrome/cache"
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
      reverse_proxy unix//${config.systemd.services.navidrome.serviceConfig.RootDirectory}/server.socket
    '';
  };
  services.caddy.virtualHosts."music.${hostname}.home" = {
    extraConfig = ''
      tls internal
      reverse_proxy unix//${config.systemd.services.navidrome.serviceConfig.RootDirectory}/server.socket
    '';
  };
}
