{ pkgs, lib, ... }:
{
  # Replace coreutils with uutils
  # Need hiPrio or else there are collisions
  environment.systemPackages = [
    (lib.hiPrio pkgs.uutils-coreutils-noprefix)
  ];
}
