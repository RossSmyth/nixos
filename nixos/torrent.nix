{ pkgs, ... }:
{
  services.transmission = {
    enable = true;
    package = pkgs.transmission_4;
    openRPCPort = true;
    openPeerPorts = true;

    # Downloads to a jellyfin-controlled dir
    downloadDirPermissions = null;

    settings = {
      # Find a way to automate sorting TV and movies
      download-dir = "/media";
      rpc-bind-address = "0.0.0.0";
      rpc-whitelist = "127.0.0.1,192.168.*.*";
    };
  };
}
