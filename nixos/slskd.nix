{
  config,
  ...
}:
let
  cfg = config.services.slskd;
in
{
  imports = [
    ./agenix.nix
  ];

  services.slskd = {
    enable = true;
    environmentFile = config.age.secrets.slskd.path;
  };

  age.secrets.slskd = {
    file = ../secrets/slskd.age;
    mode = "400";
    inherit (cfg) group;
    owner = cfg.user;
  };
}
