{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
let
  flake-compat = import inputs.flake-compat;
  niri =
    (flake-compat {
      src = inputs.niri;
      copySourceTreeToStore = false;
      useBuiltinsFetchTree = true;
    }).outputs;
in
{
  imports = [
    niri.nixosModules.niri
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
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      common.default = [ "gkt" ];
      niri = {
        default = [
          "gtk"
          "gnome"
        ];
        "org.freedesktop.impl.portal.ScreenCast" = "gnome";
        "org.freedesktop.impl.portal.Screenshort" = "gnome";
        "org.freedesktop.impl.portal.FileChooser" = "gtk";
      };
    };
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
  };

  # No swaylock pam module :/ https://github.com/NixOS/nixpkgs/issues/143365
  security.pam.services.swaylock = { };

  # The niri agent messes with it.
  systemd.user.services.niri-flake-polkit.enable = false;
  security.soteria.enable = true;

  nixpkgs.overlays = [
    niri.overlays.niri
  ];
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "niri";
  };
  programs.niri = {
    package = pkgs.niri;
    enable = true;
  };
}
