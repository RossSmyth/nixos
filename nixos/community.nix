{ config, ... }: {
  imports = [
    ./agenix.nix
  ];

  # IdentityFile
  age.secrets.community = {
    file = ../secrets/community.age;
    mode = "400";
    group = config.nix.daemonGroup;
    owner = config.nix.daemonUser;
  };

  programs.ssh.hosts."*.nix-community.org" = {
    order = 100;
    User = "rsmyth";
    IdentityFile = config.age.secrets.community.path;
  };
}
