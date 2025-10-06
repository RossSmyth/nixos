{
  lib,
  pkgs,
  user,
  ...
}:
{
  home = {
    username = user;
    homeDirectory = "/home/" + user;
    packages = [
      pkgs.fq
      pkgs.jq
      pkgs.hexyl
    ]
    ++ lib.optionals (!pkgs.stdenv.hostPlatform.isRiscV) [
      pkgs.nix-output-monitor
    ];
  };
}
