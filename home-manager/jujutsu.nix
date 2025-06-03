{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  programs.jujutsu = {
    enable = true;
    package = inputs.jujutsu.packages.${pkgs.system}.default.overrideAttrs (
      final: prev: {
        env.RUSTFLAGS =
          prev.env.RUSTFLAGS + " -Ctarget-cpu=native -Cpanic=abort -Clto=thin -Cembed-bitcode=yes";
        doCheck = false;
      }
    );
    settings = {
      user = {
        name = "Ross Smyth";
        # Email is a per-repo thing.
      };
      ui = {
        default-command = [
          "log"
          "--reversed"
        ];
        pager = {
          command = [
            (lib.getExe pkgs.less)
            "-FRX"
          ];
          env = {
            LESSCHARSET = "utf-8";
          };
        };
      };
      diff.tool = "difft";
      merge-tools.difft = {
        program = lib.getExe pkgs.difftastic;
        diff-args = [
          "--color=always"
          "$left"
          "$right"
        ];
      };
      merge-tools.mergiraf = {
        program = lib.getExe pkgs.mergiraf;
        merge-args = [
          "merge"
          "$base"
          "$left"
          "$right"
          "-o"
          "$output"
          "--fast"
        ];
        merge-conflict-exit-code = [ 1 ];
      };
      git = {
        colocate = true;
        write-change-id-header = true;
      };
      snapshot.auto-update-stale = true;
    };
  };
}
