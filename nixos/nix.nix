# Nix+Nixpkgs settings
{
  config,
  user,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.lix-module.nixosModules.default
  ];

  nixpkgs = {
    config = {
      microsoftVisualStudioLicenseAccepted = true;
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };

    overlays = [
      (import inputs.rust-overlay)
    ];
  };

  nix = {
    settings = {
      trusted-users = [ user ];
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
  # Without these I cannot build the system without doing silly stuff
  environment.systemPackages = with pkgs; [
    git
    nom
  ];
}
