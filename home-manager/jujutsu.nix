{
  pkgs,
  lib,
  inputs,
  config,
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
            (lib.getExe config.programs.less.package)
            "-FRX"
          ];
          env = {
            LESSCHARSET = "utf-8";
          };
        };
      };
      diff.tool = "difft";
      merge-tools.difft = {
        program = lib.getExe config.programs.git.difftastic.package;
        diff-args = [
          "--color=always"
          "$left"
          "$right"
        ];
      };
      merge-tools.mergiraf = {
        program = lib.getExe config.programs.mergiraf.package;
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
      templates = {
        draft_commit_description = ''
          concat(
            description,
            surround(
              "\nJJ: This commit contains the following changes:\n", "",
              indent("JJ:     ", diff.summary()),
            ),
            surround(
              "\nJJ: This commit contains the following changes:\n", "",
              indent("JJ:     ", diff.stat(72)),
            ),
            "\n",
            "JJ: ignore-rest\n",
            diff.git(),
          )
        '';
      };
    };
  };
}
