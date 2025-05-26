# Nix+Nixpkgs settings
{ config, ... }:
{
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  nix = {
    settings = {
      trusted-users = [ "rsmyth" ];
      experimental-features = "nix-command flakes";
      flake-registry = "";
      nix-path = config.nix.nixPath;
      accept-flake-config = true;
      auto-optimise-store = true;
      keep-derivations = true;
      keep-outputs = true;
    };
    channel.enable = false;
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };

  system.rebuild.enableNg = true;
}
