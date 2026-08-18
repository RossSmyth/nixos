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

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
