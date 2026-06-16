{ config, ... }:
{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = config.programs.nushell.enable;
    settings = {
      shlvl = {
        disabled = false;
      };
    };
  };
}
