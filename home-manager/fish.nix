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
  };
  home.shellAliases = {
    cat = "${lib.getExe config.programs.bat.package} --paging=never";
    getLargest = "${lib.getExe config.programs.fd.package} -t file . --exec ls -s | sort -nr | head -n20";
    scratch = ''systemd-run --property=PrivateTmp=true --description "scratch shell" --user --collect --shell --working-dir "/var/tmp"'';
  };
}
