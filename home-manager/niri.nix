{ pkgs, inputs, ... }:
{
  imports = [
    inputs.niri.homeModules.niri
  ];
  
  # Needed for wayland
  home.packages = with pkgs; [
    wl-clipboard-rs
  ];

  # Notification daemon
  services.mako = {
    enable = true;
    settings.default-timeout = 5;
  };

  # Secrets
  services.gnome-keyring.enable = true;

  programs.niri = {
    package = pkgs.niri;
    enable = true;
  };
}
