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
      pkgs._7zz
    ]
    ++ lib.optionals (!pkgs.stdenv.hostPlatform.isRiscV) [
      pkgs.nix-output-monitor
    ];
  };
}
