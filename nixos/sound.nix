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

  # Don't suspend audio interfaces cause it's really annoying
  services.pipewire.wireplumber.extraConfig."99-disable-suspend" = {
    "monitor.alsa.rules" = [
      {
        matches = [
          {
            "node.name" = "~alsa_input.*";
          }
          {
            "node.name" = "~alsa_output.*";
          }
        ];
        actions = {
          update-props = {
            "node.pause-on-idle" = false;
            "session.suspend-timeout-seconds" = 0;
          };
        };
      }
    ];
  };

  # To select bluetooth codecs
  environment.defaultPackages = with pkgs; [
    wiremix
  ];
}
