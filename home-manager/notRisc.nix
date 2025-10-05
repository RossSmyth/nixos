{
  inputs,
  lib,
  pkgs,
  user,
  ...
}:
{
  imports = [
    inputs.nix-index-database.homeModules.nix-index
  ];

  programs.nix-index-database.comma.enable = true;

  home = {
    username = user;
    homeDirectory = "/home/" + user;
    packages = [
      pkgs.nix-output-monitor
    ];
  };
}
