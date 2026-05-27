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
    settings = {
      revset-aliases = {
        "merge_base(x, y)" = "fork_point(x | y)";
      };
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
        program = lib.getExe config.programs.difftastic.package;
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
      fix.tools.nixfmt = {
        command = [
          "comma"
          "nixfmt"
        ];
        patterns = [ "glob:'**/*.nix'" ];
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

      # https://ddbeck.com/notes/jj-git-push-bookmark-template/
      template-aliases."slugify(str)" = ''
        truncate_end(
          65,
          str.first_line()
            .replace(regex:"[^[[:alnum:]].]", "-")
            .replace(regex:"-{2,}", "-")
            .replace(regex:"\.{2,}", ".")
            .replace(regex:"(^-+|-+$)", "")
            .lower()
        )
      '';
      templates.git_push_bookmark = ''slugify(description) ++ "/" ++ change_id.short()'';
    };
  };
}
