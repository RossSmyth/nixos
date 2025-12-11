{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
{
  imports = [
    inputs.niri.nixosModules.niri
  ];

  # Sway does not enable libinput by default.
  services.libinput.enable = true;

  # Secrets
  services.gnome.gnome-keyring.enable = true;

  # Automatically launch sway.
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${lib.getExe pkgs.tuigreet} --theme 'border=blue;text=white;prompt=green;container=black' --time --cmd niri-session";
      user = "greeter";
    };
  };

  # Allow applications to use file pickers and stuff
  xdg.portal.wlr.enable = true;
  environment.pathsToLink = [
    "/share/xdg-desktop-portal"
    "/share/applications"
  ];

  # No swaylock pam module :/ https://github.com/NixOS/nixpkgs/issues/143365
  security.pam.services.swaylock = { };

  # The niri agent messes with it.
  systemd.user.services.niri-flake-polkit.enable = false;
  security.soteria.enable = true;

  nixpkgs.overlays = [
    inputs.niri.overlays.niri
  ];
  environment.variables.NIXOS_OZONE_WL = "1";
  programs.niri = {
    package = pkgs.niri-unstable;
    enable = true;
  };
}
