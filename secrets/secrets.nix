let
  desktop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOSGfZFizgtHFeI/2khK3PTld8wnn2NiEG29yY3jXNk6 rsmyth@desktop";
  trent = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKtWNkezgvsFMTUAjXN8ZRFfY0uctPsTzquvyZwOIP7G root@trent";
  jammy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJgIsTihgkUvt/Mq0wRut+W+7TMXy6pOt6xQ9IjlKCmN rsmyth@jammy
";
in
{
  "caddy.age".publicKeys = [
    desktop
    trent
  ];

  "wasabi.age".publicKeys = [
    desktop
    jammy
    trent
  ];
}
