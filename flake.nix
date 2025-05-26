{
  inputs = {
    nixpkgs.url = "https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      ...
    }@inputs:
    let
      mkMachine = import ./mkMachine.nix inputs;
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
      nixosConfigurations = {
        desktop = mkMachine {
          hostname = "desktop";
          nixModules = [
            ./nixos/wsl.nix
            ./nixos/tmpfsTmp.nix
          ];
        };
        work = mkMachine {
          hostname = "work";
          nixModules = [
            ./nixos/wsl.nix
            ./nixos/tmpfsTmp.nix
          ];
        };
        aurora = mkMachine {
          hostname = "aurora";
          hmModules = [
            ./home-manager/alacritty.nix
            ./home-manager/wm.nix
            ./home-manager/gui.nix
          ];
          nixModules = [ ./nixos/fonts.nix ];
        };
      };
    };
}
