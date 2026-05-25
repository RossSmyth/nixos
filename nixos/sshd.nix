{
  user,
  ...
}:
{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ user ];
    };
  };

  users.users.${user}.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOSGfZFizgtHFeI/2khK3PTld8wnn2NiEG29yY3jXNk6 ${user}"
  ];
}
