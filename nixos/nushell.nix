{ config, user, ... }:
let
  hmCfg = config.home-manager.users.${user};
in
{
  users.users.${user}.shell = hmCfg.programs.nushell.package;
}
