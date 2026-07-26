{
  config,
  pkgs,
  lib,
  ...
}:
{
  # Expose to the world
  services.caddy = {
    enable = true;
    openFirewall = true;

    package = pkgs.caddy.withPlugins {
      # Need this for some reason.
      plugins = [
        "github.com/caddy-dns/cloudflare@v0.2.4"
      ];
      hash = "sha256-7GoH8YLCoPmPExQxoga2FHB58zQDoZVf1BBwkVi0SsQ=";
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

  users.users.caddy.extraGroups = lib.mkIf config.services.navidrome.enable [
    config.services.navidrome.group
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
