{ config, ... }:
let
  cfg = config.services.immich;
in
{
  # Reduce redis logs
  services.redis.servers.immich.logLevel = "warning";
  services.immich = {
    enable = true;

    # Allow access to all devices, what's the worst that could happen
    accelerationDevices = null;

    settings = {
      # Create the db dump exactly at midnight
      backup.database = {
        cronExpression = "0 0 * * *";
        keepLastAmount = 7;
      };

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

  rsmyth.backups.immich = {
    tags = [ "immich" ];
    # Immich create db dumps on a schedule, every day at midnight.
    pathsInclude = [
      cfg.mediaLocation
    ];
  };

  # Expose to the world
  services.caddy.virtualHosts."immich.rsmyth.net" = {
    extraConfig = ''
      tls {
        dns cloudflare {env.CF_API_TOKEN}
        resolvers 1.1.1.1
      }
      reverse_proxy :${cfg.port}
    '';
  };
}
