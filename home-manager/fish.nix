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
        ${lib.getExe pkgs.fastfetch}
      end
    '';
    shellAliases = {
      cat = "${lib.getExe pkgs.bat} --paging=never";
      nxswitch = "sudo nixos-rebuild switch --flake ${config.xdg.configHome}/nix";
      nxbuild = "sudo nixos-rebuild boot --flake ${config.xdg.configHome}/nix";
      nxedit = "${config.home.sessionVariables.EDITOR} ${config.xdg.configHome}/nix";
      getLargest = "${lib.getExe pkgs.fd} -t file . --exec ls -s | sort -nr | head -n20";
      dev = "nix develop --command ${lib.getExe pkgs.fish}";
      scratch = ''systemd-run --property=PrivateTmp=true --description "scratch shell" --user --collect --shell --working-dir "/var/tmp"'';
    };
  };
}
