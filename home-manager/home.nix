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
      inputs.helix.overlays.default
    ];
  };

  home = {
    username = "rsmyth";
    homeDirectory = "/home/rsmyth";
  };

  programs = {
    nix-index-database.comma.enable = true;
    
    ripgrep.enable = true;
    fd.enable = true;
    home-manager.enable = true;
    git = {
      difftastic.enable = true;
      enable = true;
      userEmail = "18294397+RossSmyth@users.noreply.github.com";
      userName = "Ross Smyth";
      aliases = {
        amend = "commit --amend --no-edit";
        cm    = "commit -m";
      };
      extraConfig = {
        push.default = "current";
        push.autoSetupRemote = true;
        core.autocrlf = false;
        pull.ff = "only";
        init.defaultBranch = "main";
        merge.conflictstyle = "zdiff3";
        blame.ignoreRevsFile = ".git-blame-ignore-revs";
      };
    };

    fish = {
      enable = true;
      interactiveShellInit = ''
        function fish_greeting
          ${pkgs.fastfetch}/bin/fastfetch
        end
      '';
      shellAliases = {
        cat = "bat --paging=never";
        nxswitch = "sudo nixos-rebuild switch --flake ${config.xdg.configHome}/nix";
        nxbuild  = "sudo nixos-rebuild boot --flake ${config.xdg.configHome}/nix";
        nxedit  = "${config.home.sessionVariables.EDITOR} ${config.xdg.configHome}/nix";
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
