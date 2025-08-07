{
  pkgs,
  lib,
  config,
  ...
}:
{

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      function fish_greeting
        ${lib.getExe config.programs.fastfetch.package}
      end
    '';
    shellAliases = {
      update = ''${lib.getExe config.nix.package} flake update -L --show-trace --log-format internal-json &| ${lib.getExe pkgs.nom} --json'';
      nbuild = ''${lib.getExe pkgs.nixos-rebuild-ng} boot --log-format internal-json --show-trace --flake ${config.xdg.configHome}# &| ${lib.getExe pkgs.nom} --json'';
    };
  };
  home.shellAliases = {
    cat = "${lib.getExe config.programs.bat.package} --paging=never";
    nxedit = "${config.home.sessionVariables.EDITOR} ${config.xdg.configHome}/nix";
    getLargest = "${lib.getExe config.programs.fd.package} -t file . --exec ls -s | sort -nr | head -n20";
    dev = "nix develop --command ${config.home.sessionVariables.EDITOR}";
    scratch = ''systemd-run --property=PrivateTmp=true --description "scratch shell" --user --collect --shell --working-dir "/var/tmp"'';
  };
}
