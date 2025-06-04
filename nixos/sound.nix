{ pkgs, ... }:
{
  # Enable sound.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # To select bluetooth codecs
  environment.defaultPackages = with pkgs; [
    pulsemixer
  ];
}
