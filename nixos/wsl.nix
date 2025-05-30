{ inputs, user, ... }:
{
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];
  wsl.enable = true;
  wsl.defaultUser = user;
  wsl.interop.includePath = false;
}
