{
  lib,
  stdenvNoCC,
  replace-secrets,
}:
# Usage:
# ```nix
# let
#   cfg = config.services.something;
#
#   credSub = secretSwap {
#     # The config file with sentinel values written to it for replacing.
#     # Not always avaliable :/
#     toReplace = cfg.configFile;
#
#     # AttrSet of user-friendly names of secrets, and
#     # paths to files that contain the raw literal secret value
#     secrets = {
#       # If using systemd-creds/LoadCredential
#       # This is the only field that accepts environment variables.
#       password = "$CREDENTIALS_DIRECTORY/password"
#       # Agenix/sops/something
#       api-token = config.age.secrets.api-token.path;
#     };
#
#     # Optional: Give it a nice name
#     fileName = "config.toml"
#
#     # User and group to chown the substituted file
#     # The final file will be read-only.
#     user = cfg.user;
#     group = cfg.group;
#
#     # directory to place the file. Highly recommend that it is
#     # the systemd RuntimeDirectory so that its lifetime is tied
#     # to the service itself.
#     runtimeDir = "/run/myService";
#
#     # Optional: Friendly file name
#     fileName = "config.json"
#   };
# in
# {
#   config.services.something {
#     # Inserts sentinel values into the config file to later be replaced
#     settings = {
#       password = credSub.password;
#       api-token = credSub.api-token;
#     };
#
#     # Set the real path to the runtime path
#     # Often not possible, and `systemd.services.*.serviceConfig.Exec` will need to be overriden.
#     configPath = credSub.substitutedPath;
#   };
#
#   systemd.services.something.serviceConfig.PreExec = [
#     credSub
#   ];
# }
lib.extendMkDerivation {
  constructDrv = stdenvNoCC.mkDerivation;

  excludeDrvArgNames = [
    "toReplace"
    "secrets"
    "runtimeDir"
    "fileName"
  ];

  extendDrvArgs =
    finalAttrs:
    {
      # Path
      #
      # Path to find the file that will have substitutions done
      toReplace,
      # AttrSet Path
      #
      # Key = user-friendly name
      # Value = path to find the secret
      secrets,
      runtimeDir,
      user,
      group,
      fileName ? toReplace.pname or toReplace.name or "secretSwap",
    }:
    let
      runtimePath = "${runtimeDir}/${fileName}";
      # Make sentinels for easy search and replace by hashing the name+path
      sentinels = lib.mapAttrs (name: path: builtins.hashString "sha256" "${name}${path}");
    in
    {
      pname = fileName + "-replacer";
      version = "none";

      strictDeps = true;
      __structuredAttrs = true;

      doConfigure = false;
      doUnpack = false;
      doBuild = false;
      doFixup = false;

      passthru = {
        inherit runtimePath;
      }
      // sentinels;

      script = ''
        #!/usr/bin/env bash
        cp '${toReplace}' '${runtimePath}'
        chown '${user}:${group}' '${runtimePath}'
        chmod 0600 '${runtimePath}'
      ''
      + (lib.concatMapStringsSep "\n" (
        name: sentinel:
        ''${lib.getExe replace-secrets} '${sentinel}' "${secrets.${name}}" '${runtimePath}'  ''
      ) sentinels)
      + ''
        chmod 0400 '${runtimePath}'
      '';

      installPhase = ''
        printf '%s' "$script" > "$out"          
      '';
    };
}
