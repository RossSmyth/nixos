{ inputs, ... }:
{
  imports = [
    inputs.nixos-wsl.nixosModules.default
    {
      wsl.enable = true;
      wsl.defaultUser = "rsmyth";
      wsl.interop.includePath = false;
    }
  ];
}
