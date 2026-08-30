{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
{
  # Sway does not enable libinput by default.
  services.libinput.enable = true;

  # Automatically launch niri.
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
      common.default = [ "gtk" ];
      niri = {
        "org.freedesktop.impl.portal.ScreenCast" = "gnome";
        "org.freedesktop.impl.portal.Screenshot" = "gnome";
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

  security.soteria.enable = true;

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
