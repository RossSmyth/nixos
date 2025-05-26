{ pkgs, lib, ... }:
{
  # Replace coreutils with uutils
  # Need hiPrio or else there are collisions
  environment.systemPackages = with pkgs; [
    (lib.hiPrio uutils-coreutils-noprefix)
  ];
}
