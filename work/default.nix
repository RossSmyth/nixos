{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-wsl.nixosModules.default
    {
      wsl.enable = true;
      wsl.defaultUser = "rsmyth";
      wsl.interop.includePath = false;
    }
  ];
  system.stateVersion = "24.05";
}
