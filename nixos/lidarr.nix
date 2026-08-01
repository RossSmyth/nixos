{
  config,
  lib,
  modulesPath,
  ...
}:
let
  libRoot = "/media/lib/music";
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

  # This needs to go somewhere else
  systemd.tmpfiles.settings."10-lidarr" = {
    "/media/lib".d = {
      mode = "0755";
      user = "root";
      group = "root";
    };
  };

  services.lidarr = {
    enable = true;
    settings = {
      app.instancename = "rsmyth music managment";
      server.urlbase = "lidarr.rsmyth.net";
    };

    libraryPaths = [
      libRoot
    ];
  };

  # For local routing
  services.caddy.virtualHosts."lidarr.rsmyth.net" = {
    extraConfig = ''
      	@public not remote_ip private_ranges
       	abort @public

        reverse_proxy :${toString cfg.settings.server.port}
    '';
  };

  rsmyth.backups.services.lidarr = {
    # Include the music dir? For now, no.
    pathsInclude = [
      "/var/lib/lidarr"
    ];
    preBackupScript = ''
      systemctl stop lidarr.service
    '';
    postBackupScript = ''
      systemctl start lidarr.service
    '';
  };
}
