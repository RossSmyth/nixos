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
    ./ripgrep.nix
    ./bat.nix
  ]
  ++ extraModules;

  programs = {
    fd.enable = true;
    home-manager.enable = true;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
