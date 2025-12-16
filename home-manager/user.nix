{
  lib,
  pkgs,
  user,
  ...
}:
{
  home = {
    preferXdgDirectories = true;
    username = user;
    homeDirectory = "/home/" + user;
    packages = [
      pkgs.fq
      pkgs.jaq
      pkgs.hexyl
    ]
    ++ lib.optionals (!pkgs.stdenv.hostPlatform.isRiscV) [
      pkgs.nix-output-monitor
    ];
  };
}
