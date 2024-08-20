{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-wsl.nixosModules.default
    {
      wsl.enable = true;
      wsl.defaultUser = "rsmyth";
      wsl.interop.includePath = false;
    }
  ];
  networking.hostName = "desktop";
  system.stateVersion = "24.05";
}
