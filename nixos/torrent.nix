{
  hostname,
  pkgs,
  config,
  lib,
  ...
}:
{
  services.rtorrent = {
    enable = true;
    downloadDir = "/media/torrents";
    configText = [
      "throttle.min_peers.normal.set = 40"
      "throttle.max_peers.normal.set = 52"
      "throttle.min_peers.seed.set = 10"
      "throttle.max_peers.seed.set = 52"
      "throttle.max_uploads.set = 8"
      "throttle.global_down.max_rate.set = 200"
      "throttle.global_up.max_rate.set = 28"
      "pieces.hash.on_completion.set = yes"
      "dht.mode.set = auto"
      "protocol.pex.set = yes"
      "ratio.enable="
      "ratio.min.set = 100" # 100%
      "ratio.max.set = 300"
      "ratio.upload.set = 250M"
      # When ratio is met, close
      "system.method.set = group.seeding.ratio.command, d.close="
      "system.umask.set = 0002"
    ];
  };
}
