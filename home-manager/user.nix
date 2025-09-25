{ pkgs, user, ... }:
{
  home = {
    username = user;
    homeDirectory = "/home/" + user;
    packages = [
      pkgs.nix-output-monitor
      pkgs.fq
      pkgs.jq
      pkgs.hexyl
    ];
  };
}
