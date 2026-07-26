{ config, lib, ... }:
let
  cfg = config.services.immich;
in
{
  imports = [
    ./restic.nix
  ];

  systemd.tmpfiles.settings."10-immich"."${cfg.mediaLocation}".d = {
    mode = "0700";
    inherit (cfg) user group;
  };

  # Reduce redis logs
  services.redis.servers.immich.logLevel = "warning";
  services.immich = {
    enable = true;

    mediaLocation = "/media/images";

    # Allow access to all devices, what's the worst that could happen
    accelerationDevices = null;

    settings = {
      # Do our own as compressed dumps are not ideal with restic.
      backup.database.enabled = false;

      ffmpeg = {
        acceptedVideoCodecs = [
          "h264"
          "hevc"
          "vp9"
          "av1"
        ];
        preset = "slow";
        # What to transcode to
        targetAudioCodec = "opus";
        targetVideoCodac = "av1";
      };

      # Encode the preview in webp
      image.preview.format = "webp";

      # Domain for sharing
      server = {
        loginPageMessage = ":3c";
        externalDomain = "https://immich.rsmyth.net";
        publicUsers = false;
      };
    };
  };

  rsmyth.backups.services.immich = {
    # Immich create db dumps on a schedule, every day at midnight.
    pathsInclude = [
      cfg.mediaLocation
    ];
    pathsExclude = [
      (cfg.mediaLocation + "/thumbs")
      (cfg.mediaLocation + "/encoded-video")
    ];
    preBackupScript = ''
      mkdir -p "${cfg.mediaLocation}/backups"
      run0 -u ${cfg.user} ${lib.getExe' config.services.postgresql.package "pg_dump"} --clean --if-exists \
        --username=${cfg.database.user} \
        --dbname=${cfg.database.name} \
        --port=${toString cfg.database.port} \
        --host=${cfg.database.host} > "${cfg.mediaLocation}/backups/immich-database.sql"
    '';
  };

  # Expose to the world
  services.caddy.virtualHosts."immich.rsmyth.net" = {
    extraConfig = ''
      tls {
        dns cloudflare {env.CF_API_TOKEN}
        resolvers 1.1.1.1
      }
      reverse_proxy localhost:${toString cfg.port}
    '';
  };
}
