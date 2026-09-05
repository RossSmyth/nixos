{ hostname, ... }: {
  imports = [
    ./nix.nix
    ./shell.nix
    ./security.nix
    ./networking.nix
    ./users.nix
    ./coreutils.nix
    ./oomd.nix
    ./keyboard.nix
  ];

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/Detroit";
  systemd.coredump.enable = true;
  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = hostname;

  # Use dbus-broker cause it's a bit better
  services.dbus.implementation = "broker";

  # Disable things I will never use
  documentation = {
    info.enable = false;
    nixos.enable = false;
  };

  # So I can have disks mounted when plugged in
  services.udisks2.enable = true;

  system.stateVersion = "24.05";
}
