{
  config,
  pkgs,
  lib,
  ...
}:
let
  buildMachines.machines = {
    comm = {
      enable = true;
      jobs = 6;
      uri = "ssh-ng://rsmyth@build-box.nix-community.org";
      ssh-key = config.age.secrets.community.path;
      supported-features = [
        "benchmark"
        "big-parallel"
        "kvm"
        "nixos-test"
        "uid-range"
      ];
      system-types = [
        "x86_64-linux"
        "riscv64-linux"
        "i686-linux"
      ];
      ssh-public-host-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIElIQ54qAy7Dh63rBudYKdbzJHrrbrrMXLYl7Pkmk88H";
    };
    aarch64-comm = {
      enable = true;
      jobs = 20;
      uri = "ssh-ng://rsmyth@aarch64-build-box.nix-community.org";
      ssh-key = config.age.secrets.community.path;
      supported-features = [
        "benchmark"
        "big-parallel"
        "kvm"
        "nixos-test"
        "uid-range"
        "gccarch-armv7-a"
        "gccarch-armv8-a"
      ];
      system-types = [
        "aarch64-linux"
        "armv7l-linux"
      ];
      ssh-public-host-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG9uyfhyli+BRtk64y+niqtb+sKquRGGZ87f4YRc8EE1";
    };
    darwin-comm = {
      enable = true;
      jobs = 10;
      uri = "ssh-ng://rsmyth@darwin-build-box.nix-community.org";
      ssh-key = config.age.secrets.community.path;
      supported-features = [
        "big-parallel"
      ];
      system-types = [
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      ssh-public-host-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKMHhlcn7fUpUuiOFeIhDqBzBNFsbNqq+NpzuGX3e6zv";
    };
  };

  builders =
    let
      format = pkgs.formats.toml { };
    in
    format.generate "machines.toml" (lib.filterAttrsRecursive (_: v: v != null) buildMachines);

  use-comm = pkgs.writers.writeBashBin "comm-build" ''
    nom build --builders-use-substitutes -j0 --builders "@${builders}" "$@"
  '';

in
{
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

  environment.systemPackages = [
    use-comm
  ];
}
