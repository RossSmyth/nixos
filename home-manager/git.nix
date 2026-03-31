{
  programs.difftastic.git.enable = true;

  programs.git = {
    enable = true;

    signing.format = null;
    settings = {
      user.name = "Ross Smyth";
      push = {
        default = "current";
        followTags = true;
        autoSetupRemote = true;
      };
      fetch = {
        prune = true;
        pruneTags = true;
        all = true;
      };
      rebase = {
        autoSquash = true;
        autoStash = true;
        updateRefs = true;
      };
      core.autocrlf = false;
      pull = {
        ff = "only";
        rebase = true;
      };
      init.defaultBranch = "main";
      merge.conflictstyle = "zdiff3";
      blame.ignoreRevsFile = ".git-blame-ignore-revs";
      help.autocorrect = "prompt";
      commit.verbose = true;
      rerere = {
        enabled = true;
        autoupdate = true;
      };
    };
  };
}
