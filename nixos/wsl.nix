{ inputs, user, ... }:
{
  imports = [
    (inputs.nixos-wsl + "/modules")
  ];
  wsl = {
    enable = true;
    defaultUser = user;
    interop.includePath = false;
    wslConf.network.generateResolvConf = false;
  };
}
