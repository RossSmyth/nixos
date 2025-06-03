extraModules:
{
  inputs,
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
    ./fd.nix
    inputs.nix-index-database.hmModules.nix-index
  ] ++ extraModules;

  programs = {
    home-manager.enable = true;
    bat.enable = true;
    nix-index-database.comma.enable = true;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
