_: {
  imports = [
    ./nix.nix
    ./shell.nix
    ./security.nix
    ./networking.nix
    ./users.nix
    ./coreutils.nix
  ];

  time.timeZone = "America/Detroit";
  systemd.coredump.enable = true;

  system.stateVersion = "24.05";
}
