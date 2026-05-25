{
  imports = [
    ./hardware-configuration.nix
  ];

  # It is a laptop server
  services.logind.settings.Login.HandleLidSwitch = "ignore";
}
