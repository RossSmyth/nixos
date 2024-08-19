{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./helix.nix
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
    home-manager.enable = true;
    helix.package = inputs.helix.packages.${pkgs.system}.default;    
    git = {
      difftastic.enable = true;
      enable = true;
      userEmail = "18294397+RossSmyth@users.noreply.github.com";
      userName = "Ross Smyth";
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
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
