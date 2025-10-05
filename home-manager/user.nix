{ pkgs, user, ... }:
{
  home = {
    username = user;
    homeDirectory = "/home/" + user;
    packages = [
      pkgs.fq
      pkgs.jq
      pkgs.hexyl
    ];
  };
}
