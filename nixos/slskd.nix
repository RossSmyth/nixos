{
  config,
  ...
}:
let
  cfg = config.services.slskd;
in
{
  imports = [
    ./agenix.nix
  ];

  services.slskd = {
    enable = true;
    environmentFile = config.age.secrets.slskd.path;
    settings = {

      # Use a unix socket for the web server
      web.socket = "/run/slskd/server.socket";
      headless = false; # Set to false once setup

      transfers = {
        upload = {
          slots = 4;
          speed_limit = 100;
        };
        download = {
          slots = 10;
          speed_limit = 1000;
        };
      };

      # This needs to be forwarded.
      soulseek.listen_port = 50301;

      # Lidarr-owned r/o directory
      shares.directories = [
        "[Music]/media/lib/music"
      ];
      # Downloaders-owned r/w directory
      directories.downloads = [
        "/media/downloads/music"
      ];

      filters.search.request = [
        "^.{1,2}$" # Discard 1-2 char requests as they are probably spam or mistakes.
      ];
    };
  };

  systemd.tmpfiles.settings."10-downloaders" = {
    "/media/downloads".d = {
      mode = "0755";
      user = "root";
      group = "root";
    };
    "/media/downloads/music".d = {
      mode = "0755";
      user = "root";
      group = "root";
    };
  };

  # tmpdir for the unix socket. Tied to the lifetime of the service.
  systemd.services.slskd.serviceConfig.RuntimeDirectory = "slskd";

  age.secrets.slskd = {
    file = ../secrets/slskd.age;
    mode = "400";
    inherit (cfg) group;
    owner = cfg.user;
  };

  services.caddy.virtualHosts."soulseek.rsmyth.net".extraConfig = ''
    	@public not remote_ip private_ranges
     	abort @public

      reverse_proxy unix//${config.systemd.services.slskd.serviceConfig.RootDirectory}/server.socket
  '';
}
