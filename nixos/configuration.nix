# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  nix = {
    settings = {
      trusted-users = ["rsmyth"];
      experimental-features = "nix-command flakes";
      flake-registry = "";
      nix-path = config.nix.nixPath;
      accept-flake-config = true;
      auto-optimise-store = true;
    };
    channel.enable = false;
    gc.automatic = true;
  };

  networking.hostName = "nixos";
  time.timeZone = "America/Detroit";

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  environment.pathsToLink = ["/share/fish"];
  environment.shells = [pkgs.fish];
  environment.enableAllTerminfo = true;

  users.users = {
    rsmyth = {
      useDefaultShell = true;
      hashedPassword = "$y$j9T$pANX.P1IbyQB2xriv3ncp/$AnA0t/0WrMitJYBivHKlcdp0d8lqbCuR0yN1zvOnDFA";
      isNormalUser = true;
      extraGroups = ["wheel"];
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
