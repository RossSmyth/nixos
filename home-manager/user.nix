{
  lib,
  pkgs,
  user,
  ...
}:
let
  # Pulls a Nixpkgs PR and attempts to apply it.
  nixpkgs-pr-puller = pkgs.writers.writeBashBin "pr-patch" {
    makeWrapperArgs = [
      "--prefix"
      "PATH"
      ":"
      (lib.makeBinPath [
        pkgs.curl
        pkgs.patch
      ])
    ];
  } ./scripts/pr.sh;

  # Scrapes Hydra logs
  hydra-log-scraper = pkgs.writers.writeBashBin "hydra-scrape" {
    makeWrapperArgs = [
      "--prefix"
      "PATH"
      ":"
      (lib.makeBinPath [
        pkgs.lixPackageSets.lix_2_96.nix-eval-jobs
        pkgs.wget
        pkgs.jaq
        pkgs.parallel
      ])
    ];
  } ./scripts/scrape-hydra.sh;
in
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
      pkgs.file
      nixpkgs-pr-puller
      hydra-log-scraper
    ]
    ++ lib.optionals (!pkgs.stdenv.hostPlatform.isRiscV) [
      pkgs.nix-output-monitor
    ];
  };
}
