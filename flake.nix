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
      inputs.rust-overlay.follows = "rust-overlay";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ripgrep = {
      url = "github:burntsushi/ripgrep";
      flake = false;
    };

    fd = {
      url = "github:sharkdp/fd";
      flake = false;
    };

    bat = {
      url = "github:sharkdp/bat";
      flake = false;
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
            ./home-manager/niri.nix
            ./home-manager/gui.nix
          ];
          nixModules = [
            ./nixos/fonts.nix
            ./nixos/run0.nix
            ./nixos/sound.nix
            ./nixos/battery.nix
            ./nixos/nvidia.nix
            ./nixos/bootloader.nix
            ./nixos/security.nix
            ./nixos/networking.nix
            ./nixos/battery.nix
            ./nixos/wm.nix
          ];
        };
      };
    };
}
