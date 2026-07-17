{ config, ... }:
let
  cfg = config.services.navidrome;
in
{
  services.navidrome = {
    enable = true;

    settings = {
      Agents = "listenbrainz";
      AlbumPlayCountMode = "normalized";
      DefaultShareExpiration = "24h";
      SessionTimeout = "10h";
      ShareURL = "music.rsmyth.net";
      UIWelcomeMessage = ":3c";
      # Setting, but we will manually create the backups to prevent thundering herds
      Backup = {
        Path = config.services.navidrome.WorkingDirectory + "/backups";
        count = 7;
      };
    };
  };

  # https://www.navidrome.org/docs/usage/configuration/options/#opt-passwordencryptionkey
  # TODO: Set this with some passphrase & agenix
  # ND_PASSWORDENCRYPTIONKEY="aaaaaaaaaaaaaa"
  #
  # systemd.services.navidrome.serviceConfig.EnvironmentFile = ...;

  rsmyth.backups.navidrome = {
    tags = [ "navidrome" ];
    pathsInclude = [
      (config.services.navidrome.WorkingDirectory + "/backups")
    ];
    # TODO: Add a managing wrapping to nixpkgs
    preBackupScript = "";
  };

  # Expose to the world
  services.caddy.virtualHosts."music.rsmyth.net" = {
    extraConfig = ''
      tls {
        dns cloudflare {env.CF_API_TOKEN}
        resolvers 1.1.1.1
      }
      reverse_proxy :${cfg.settings.Port}
    '';
  };
}
