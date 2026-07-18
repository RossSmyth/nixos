{
  security.sudo.enable = false;
  system.tools.nixos-rebuild.enableRun0Elevation = true;
  security.pam.services.systemd-run0 = {
    setEnvironment = true;
    pamMount = false;
  };
}
