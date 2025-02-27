{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./helix.nix
    inputs.nix-index-database.hmModules.nix-index
  ];

  nixpkgs = {
    overlays = [
    ];
  };

  home = {
    username = "rsmyth";
    homeDirectory = "/home/rsmyth";
    packages = [
      # Add NOM but disable the build logs
      # https://github.com/maralorn/nix-output-monitor/issues/59
      (pkgs.nix-output-monitor.overrideAttrs (final: prev: {
        patches = (prev.patches or []) ++ [./silent-nom.patch];
      }))
    ];
  };

  programs = {
    nix-index-database.comma.enable = true;
    ripgrep.enable = true;
    fd.enable = true;
    home-manager.enable = true;

    jujutsu = {
      enable = true;
      settings = {
        user = {
          name = "Ross Smyth";
          email = "";
        };

        ui.paginate = "never";
        ui.default-command = ["log" "--reversed"];
        git.subprocess = true;
        diff.tool = ["${lib.getExe pkgs.difftastic}" "--color=always" "$left" "$right"];
      };
    };
    git = {
      difftastic.enable = true;
      enable = true;
      userEmail = "18294397+RossSmyth@users.noreply.github.com";
      userName = "Ross Smyth";
      aliases = {
        amend = "commit --amend --no-edit";
        cm = "commit -m";
      };
      extraConfig = {
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

    fish = {
      enable = true;
      interactiveShellInit = ''
        function fish_greeting
          ${lib.getExe pkgs.fastfetch}
        end
      '';
      shellAliases = {
        cat = "bat --paging=never";
        nxswitch = "sudo nixos-rebuild switch --flake ${config.xdg.configHome}/nix";
        nxbuild = "sudo nixos-rebuild boot --flake ${config.xdg.configHome}/nix";
        nxedit = "${config.home.sessionVariables.EDITOR} ${config.xdg.configHome}/nix";
        getLargest = "${lib.getExe pkgs.fd} -t file . --exec ls -s | sort -nr | head-n20";
        dev = "nix develop --command ${lib.getExe pkgs.fish}";
        scratch = ''systemd-run --property=PrivateTmp=true --description "scratch shell" --user --collect --shell --working-dir "/var/tmp"'';
      };
    };

    starship = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        shlvl = {
          disabled = false;
        };
      };
    };
    bat = {
      enable = true;
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
