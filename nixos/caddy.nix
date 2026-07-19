{ config, pkgs, ... }:
{
  # Expose to the world
  services.caddy = {
    enable = true;

    package = pkgs.caddy.withPlugins {
      # Need this for some reason.
      plugins = [
        "github.com/caddy-dns/cloudflare@v0.2.4"
      ];
      hash = "sha256-hEHgAG0F0ozHRAPuxEqLyTATBrE+pajeXDiSNwniorg=";
    };

    # Just log for journald
    logFormat = ''
      output stdout
      format console
    '';
  };

  # For local tls
  systemd.services.caddy.path = [
    pkgs.nss.tools
  ];

  # oooooooo secretssss
  systemd.services.caddy.serviceConfig.EnvironmentFile = [
    config.age.secrets.caddy.path
  ];

  # This needs to be here or machines will get upset
  # aka, only the machines that can decrypt can have
  # this in their config
  age.secrets.caddy = {
    file = ../secrets/caddy.age;
    mode = "400";
    group = config.services.caddy.group;
    owner = config.services.caddy.user;
  };
}
