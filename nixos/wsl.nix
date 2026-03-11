{ inputs, user, ... }:
{
  imports = [
    (inputs.nixos-wsl + "/modules")
  ];
  wsl.enable = true;
  wsl.defaultUser = user;
  wsl.interop.includePath = false;
}
