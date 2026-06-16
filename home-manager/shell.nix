{
  lib,
  pkgs,
  config,
  ...
}:
{
  home.shellAliases = {
    jq = "${lib.getExe pkgs.jaq}";
    cat = "${lib.getExe config.programs.bat.package} --paging=never";
    getLargest = "${lib.getExe config.programs.fd.package} -t file . --exec ls -s | sort -nr | head -n20";
    scratch = ''systemd-run --property=PrivateTmp=true --description "scratch shell" --user --collect --shell --working-dir "/var/tmp"'';
  };
}
