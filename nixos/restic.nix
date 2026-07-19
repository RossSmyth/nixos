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
  options.rsmyth.backups.enable = lib.mkEnableOption "rsmyth.backups";

  options.rsmyth.backups.services = lib.mkOption {
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
          postBackupScript = lib.mkOption {
            type = types.nullOr types.str;
            default = null;
            description = ''
              Script to run after backup.
            '';
          };

          tags = lib.mkOption {
            type = types.listOf types.str;
            default = [ ];
            defaultText = lib.literalExpression ''
              tags = [] ++ attrName
            '';
            description = ''
              Tags for this backup. Adds the attribute name as a tag unconditionally.
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

  config = lib.mkIf cfg.enable {
    services.restic.backups = lib.mapAttrs (name: backup: {
      initialize = true;
      backupPrepareCommand = backup.preBackupScript;
      backupCleanupCommand = backup.postBackupScript;
      runCheck = true;

      # Will be made with agenix, but needs to look something like:
      environmentFile = config.age.secrets.wasabi.path;

      paths = backup.pathsInclude;
      extraBackupArgs = [
        "--host=${hostname}"
        "--cleanup-cache"
      ]
      ++ (lib.map (p: "--exclude=${p}") backup.pathsExclude)
      ++ (lib.map (t: "--tag=${t}") (backup.tags ++ [ name ]));

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

      repository = "s3:https://s3.us-east-1.wasabisys.com/rsmyth-restic";
      timerConfig = {
        OnCalendar = "daily";
        RandomizedOffsetSec = "3h";
        Persistent = true;
      };
    }) cfg.services;

    # This needs to be scoped only to the machines that need it.
    age.secrets.wasabi = {
      file = ../secrets/wasabi.age;
      mode = "400";
      # Restic just run as root rn because it has to read
      # a bunch of service's files.
      group = "root";
      owner = "root";
    };

  };
}
