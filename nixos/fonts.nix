{ pkgs, ... }:
{
  # NixOS Font config

  # IDK this is good enough
  console = {
    font = "Lat2-Terminus16";
    earlySetup = true;
  };

  # System-wide fonts
  fonts = {
    packages = with pkgs; [
      nerd-fonts.inconsolata
      nerd-fonts.noto
      noto-fonts-color-emoji
    ];

    # Font defaults
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "NotoSerif Nerd Font" ];
        sansSerif = [ "NotoSans Nerd Font" ];
        monospace = [ "Inconsolata Nerd Font Mono" ];
      };
    };
  };
}
