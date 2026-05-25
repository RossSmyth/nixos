{ pkgs, ... }:
{
  services.transmission = {
    enable = true;
    package = pkgs.transmission_4;
    openRPCPort = true;
    openPeerPorts = true;

    settings = {
      rpc-bind-address = "0.0.0.0";
      rpc-whitelist = "127.0.0.1,192.168.*.*";
    };
  };
}
