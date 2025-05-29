{
  security.sudo.enable = false;
  security.pam.services.systemd-run0 = {
    setEnvironment = true;
    pamMount = false;
  };
}
