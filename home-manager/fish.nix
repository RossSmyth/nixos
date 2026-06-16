{
  lib,
  config,
  ...
}:
{
  programs.atuin.enableFishIntegration = true;
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      function fish_greeting
        ${lib.getExe config.programs.fastfetch.package.minimal}
      end
    '';
  };
}
