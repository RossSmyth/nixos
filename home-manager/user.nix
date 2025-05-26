{ pkgs, ... }:
{
  home = {
    username = "rsmyth";
    homeDirectory = "/home/rsmyth";
    packages = [
      pkgs.nix-output-monitor
    ];
  };
}
