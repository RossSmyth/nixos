{
  hostname,
  lib,
  pkgs,
  ...
}:
let
  fixed-brotli = pkgs.brotli.overrideAttrs (
    finalAttrs: prevAttrs: {
      version = "1.2.1";
      src = pkgs.fetchFromGitHub {
        owner = "google";
        repo = "brotli";
        tag = "v${finalAttrs.version}";
        hash = "sha256-llY72cYffDv0ugsH0p89xIPEbElV4L8u7U/Fe8hT3gI=";
      };
    }
  );

  fixed-brotli-32 = pkgs.pkgsi686Linux.brotli.overrideAttrs (
    finalAttrs: prevAttrs: {
      version = "1.2.1";
      src = pkgs.fetchFromGitHub {
        owner = "google";
        repo = "brotli";
        tag = "v${finalAttrs.version}";
        hash = "sha256-llY72cYffDv0ugsH0p89xIPEbElV4L8u7U/Fe8hT3gI=";
      };
    }
  );
in
{
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

  # Remove random dumb default crap
  environment.defaultPackages = lib.mkForce [ ];

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

  system.replaceDependencies.replacements = [
    {
      oldDependency = pkgs.brotli;
      newDependency = fixed-brotli;
    }
    {
      oldDependency = pkgs.brotli.lib;
      newDependency = fixed-brotli.lib;
    }
    {
      oldDependency = pkgs.pkgsi686Linux.brotli;
      newDependency = fixed-brotli-32;
    }
    {
      oldDependency = pkgs.pkgsi686Linux.brotli.lib;
      newDependency = fixed-brotli-32.lib;
    }
  ];
}
