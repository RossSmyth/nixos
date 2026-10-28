extraModules:
{
  lib,
  inputs,
  pkgs,
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
in
{
  imports = [
    ./helix.nix
    ./user.nix
    ./jujutsu.nix
    ./git.nix
    ./shell.nix
    ./fish.nix
    ./starship.nix
    ./btop.nix
    (inputs.nix-index-database + "/home-manager-module.nix")
  ]
  ++ extraModules;

  programs = {
    bat.enable = true;
    fd.enable = true;
    ripgrep.enable = true;
    home-manager.enable = true;
    nix-index-database.comma.enable = !pkgs.stdenv.hostPlatform.isRiscV;
    nix-index.enable = !pkgs.stdenv.hostPlatform.isRiscV;
  };

  # automount drives
  services.udiskie = {
    enable = true;
    tray = "never";
  };

  home.packages = [
    nixpkgs-pr-puller
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
