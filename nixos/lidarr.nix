{
  config,
  lib,
  modulesPath,
  ...
}:
let
  libRoot = "/media/lib";
  cfg = config.services.lidarr;
in
{
  imports = [
    ./test/lidarr.nix
  ];

  disabledModules = [
    (modulesPath + "/services/misc/servarr/lidarr.nix")
  ];

  users.users.${cfg.user}.extraGroups = lib.mkIf config.services.rtorrent.enable [
    config.services.rtorrent.group
  ];

  systemd.tmpfiles.settings."10-lidarr"."${libRoot}/music".d = {
    mode = "0744";
    inherit (cfg) user group;
  };

  services.lidarr = {
    enable = true;
    settings = {
      app.instancename = "rsmyth music managment";
      server.urlbase = "lidarr.rsmyth.net";
    };
  };

  # TODO: Backups & Caddy
}
