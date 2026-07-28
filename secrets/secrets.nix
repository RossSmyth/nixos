let
  desktop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOSGfZFizgtHFeI/2khK3PTld8wnn2NiEG29yY3jXNk6 rsmyth@desktop";
  trent = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKtWNkezgvsFMTUAjXN8ZRFfY0uctPsTzquvyZwOIP7G root@trent";
  jammy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJgIsTihgkUvt/Mq0wRut+W+7TMXy6pOt6xQ9IjlKCmN rsmyth@jammy";
  aurora = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFR1Kh2QtsaeYgsNG/w9kFzd8IF42k4wZcE17W92mkXx rsmyth@aurora";
in
{
  "caddy.age".publicKeys = [
    desktop
    trent
    jammy
  ];

  "wasabi.age".publicKeys = [
    desktop
    jammy
    trent
  ];

  "navidrome.age".publicKeys = [
    desktop
    jammy
  ];
  "slskd.age".publicKeys = [
    desktop
    jammy
    aurora
  ];
}
