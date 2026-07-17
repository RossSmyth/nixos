{
  hostname,
  config,
  lib,
  ...
}:
let
  cfg = config.rsmyth.backups;
  types = lib.types;
in
{
  options.rsmyth.backups = lib.mkOption {
    description = "Backup config for each service, mainly for tagging.";
    default = { };
    type = types.attrsOf (
      types.submodule {
        options = {
          preBackupScript = lib.mkOption {
            type = types.nullOr types.str;
            default = null;
            description = ''
              Script to run before backup.
            '';
          };

          tags = lib.mkOption {
            type = types.listOf types.str;
            default = [ ];
            description = ''
              Tags for this backup
            '';
          };

          name = lib.mkOption {
            types = types.str;
            description = ''
              Name for this backup
            '';
          };

          pathsInclude = lib.mkOption {
            type = types.listOf types.str;
            description = ''
              Paths to backup.
            '';
          };

          pathsExclude = lib.mkOption {
            type = types.listOf types.str;
            default = [ ];
            description = ''
              Paths not to backup.
            '';
          };
        };
      }
    );
  };

  config.services.restic.backups = lib.mapAttrs (backup: {
    initialize = true;
    backupCleanupCommand = backup.preBackupScript;
    # Will be made with agenix, but needs to look something like:
    environmentFile = ''
      AWS_ACCESS_KEY_ID=
      AWS_SECRET_ACCESS_KEY=
    '';
    runCheck = true;
    paths = backup.pathsInclude;
    extraBackupArgs = [
      "--host=${hostname}"
      "--cleanup-cache"
    ]
    ++ (lib.map (p: "--exclude=${p}") cfg.pathsExclude)
    ++ (lib.map (t: "--tag=${t}") cfg.tags);
    # Rolling pruning of backups
    pruneOpts = [
      # Keep last 7 days of backups
      "--keep-daily"
      "7"
      # Keep last 5 weeks of backups
      "--keep-weekly"
      "5"
      # Keep all monthly backups
      "--keep-monthly"
      "unlimited"
    ];
    repository = "s3:https://s3.us-east-1.wasabisys.com/restic";
    timerConfig = {
      OnCalendar = "daily";
      RandomizedOffsetSec = "3h";
      Persistent = true;
    };
  }) cfg;
}
