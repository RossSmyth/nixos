{
  services.transmission = {
    enable = true;
    openRPCPort = true;
    openPeerPorts = true;

    settings = {
      rpc-bind-address = "0.0.0.0";
      rpc-whitelist = "127.0.0.1,192.168.*.*";
    };
  };
}
