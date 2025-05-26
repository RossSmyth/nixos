{ pkgs, lib, ... }:
{
  # NixOS Font config

  # IDK this is good enough
  console.font = "Lat2-Terminus16";

  # System-wide fonts
  fonts = {
    packages = with pkgs; [
      nerd-fonts.inconsolata
      nerd-fonts.noto
      noto-fonts-emoji
    ];

    # Font defaults
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
        monospace = [ "Inconsolata Nerd Font Mono" ];
      };
    };
  };
}
