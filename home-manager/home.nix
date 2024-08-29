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
      };
    };

    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # disable fish greeting
      '';
      shellAliases = {
        cat = "bat --paging=never";
      };
    };

    starship = {
      enable = true;
      enableFishIntegration = true;
    };
    bat = {
      enable = true;
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
