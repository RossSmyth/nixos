extraModules:
{
  lib,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./helix.nix
    ./user.nix
    ./jujutsu.nix
    ./git.nix
    ./fish.nix
    ./starship.nix
    inputs.nix-index-database.homeModules.nix-index
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

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
