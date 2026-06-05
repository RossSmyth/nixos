{ pkgs, config, ... }:
{
  # So Transmission can place files in jf's media folder
  users.users.${config.services.transmission.user}.extraGroups = [
    config.services.jellyfin.group
  ];

  services.transmission = {
    enable = true;
    package = pkgs.transmission_4;
    openRPCPort = true;
    openPeerPorts = true;

    # Downloads to a jellyfin-controlled dir
    downloadDirPermissions = null;

    settings = {
      # Find a way to automate sorting TV and movies
      rpc_bind_address = "0.0.0.0";
      rpc_whitelist = "127.0.0.1,192.168.*.*";
      rpc_host_whitelist = "trent.local";
      speed_limit_up_enable = true;
      speed_limit_down_enabled = true;
      speed_limit_down = "1000";
      ratio_limit_enable = true;
    };
  };
}
