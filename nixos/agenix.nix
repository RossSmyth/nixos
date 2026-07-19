{ inputs, config, ... }:
{
  imports = [
    "${inputs.agenix}/modules/age.nix"
  ];

  # I don't want bash junk handling my secrets thx
  nixpkgs.overlays = [
    (final: _: {
      agenix = final.ragenix;
    })
  ];

  age.secrets.caddy = {
    file = ../secrets/caddy.age;
    mode = "400";
    group = config.services.caddy.group;
    owner = config.services.caddy.user;
  };

  age.secrets.caddy = {
    file = ../secrets/wasabi.age;
    mode = "400";
    # Restic just run as root rn because it has to read
    # a bunch of service's files.
    group = "root";
    owner = "root";
  };
}
