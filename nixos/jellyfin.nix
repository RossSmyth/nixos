{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  # Expose to the world
  services.caddy = {
    enable = true;

    virtualHosts."jellyfin.rsmyth.net".extraConfig = ''
      reverse_proxy :8096
    '';
  };
}
