let
  local = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOSGfZFizgtHFeI/2khK3PTld8wnn2NiEG29yY3jXNk6 rsmyth@desktop";
  remote = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKtWNkezgvsFMTUAjXN8ZRFfY0uctPsTzquvyZwOIP7G root@trent";
in
{
  "caddy.age".publicKeys = [
    local
    remote
  ];
}
