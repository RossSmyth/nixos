{
  hostname,
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.services.deluge;
  # The dl root, files shouldn't actually go here
  dlRoot = cfg.config.download_location;
in
{
  systemd.tmpfiles.settings."10-deluged".${dlRoot}.d.mode = lib.mkForce "0755";
  systemd.tmpfiles.settings."10-deluged" =
    lib.genAttrs [ "${dlRoot}/movies" "${dlRoot}/music" "${dlRoot}/tv" ]
      (_: {
        d = {
          mode = "0755";
          inherit (cfg) user group;
        };
      });

  services.deluge = {
    enable = true;
    declarative = true;

    config = {
      download_location = "/media/torrents";
      max_download_speed = "1000";
      stop_seed_at_ratio = true;
      stop_seed_ratio = 2;
    };
  };

  # TODO: Backups & Caddy
}
