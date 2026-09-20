{
  user,
  hostname,
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

    # Keys for agenix
    # Migration: cp key from etc to /var/lib/ssh before activation
    hostKeys = [
      {
        type = "ed25519";
        comment = "${user}@${hostname}";
        path = "/var/lib/ssh/ssh_host_ed25519_key";
      }
    ];
  };

  users.users.${user}.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOSGfZFizgtHFeI/2khK3PTld8wnn2NiEG29yY3jXNk6 ${user}"
  ];
}
