{ config, user, ... }:
let
  hmCfg = config.home-manager.users.${user};
in
{
  programs.fish.enable = true;
  users.defaultUserShell = hmCfg.programs.fish.package;
  environment.pathsToLink = [
    "/share/fish"
    "/share/nushell"
  ];
  environment.shells = [
    hmCfg.programs.fish.package
    hmCfg.programs.nushell.package
  ];
}
