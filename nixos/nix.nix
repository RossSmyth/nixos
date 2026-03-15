# Nix+Nixpkgs settings
{
  lib,
  config,
  user,
  inputs,
  pkgs,
  ...
}:
{
  nixpkgs = {
    config = {
      microsoftVisualStudioLicenseAccepted = true;
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  nix = {
    package = pkgs.lixPackageSets.git.lix;
    nixPath = [ "nixpkgs=/etc/nixos/nixpkgs" ];
    settings = {
      trusted-users = [ user ];
      experimental-features = "nix-command flakes";
      nix-path = config.nix.nixPath;
      accept-flake-config = true;
      auto-optimise-store = true;
      keep-derivations = true;
      keep-outputs = true;
    };
    channel.enable = false;
    gc.automatic = true;
  };

  # Pin nixpkgs to a symlink in /etc
  environment.etc = {
    "nixos/nixpkgs".source = builtins.storePath pkgs.path;
  };

  # Without these I cannot build the system without doing silly stuff
  environment.systemPackages = with pkgs; [
    git
    nom
    npins
    colmena
  ];
}
