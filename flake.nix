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
      url = "github:RossSmyth/helix/nixRisc";
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

    lix = {
      url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
      flake = false;
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.lix.follows = "lix";
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

    jujutsu = {
      url = "github:RossSmyth/jj/riscExpose";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };

    nixos-hardware = {
      url = "github:nixos/nixos-hardware";
    };

    colmena = {
      url = "github:zhaofengli/colmena";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      colmena,
      ...
    }@inputs:
    let
      mkMachine = import ./mkMachine.nix inputs;
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;

      colmenaHive = colmena.lib.makeHive (
        {
          meta = {
            nixpkgs = import nixpkgs {
              system = "x86_64-linux";
            };
            nodeSpecialArgs.desktop = {
              inherit inputs;
              user = "rsmyth";
              hostname = "desktop";
            };
            nodeSpecialArgs.work = {
              inherit inputs;
              user = "rsmyth";
              hostname = "work";
            };
            nodeSpecialArgs.aurora = {
              inherit inputs;
              user = "rsmyth";
              hostname = "aurora";
            };
            nodeSpecialArgs.riscy = {
              inherit inputs;
              user = "rsmyth";
              hostname = "riscy";
            };
          };

        }
        // (nixpkgs.lib.mergeAttrsList [
          (mkMachine {
            hostname = "desktop";
            nixModules = [
              ./nixos/wsl.nix
              ./nixos/tmpfsTmp.nix
            ];
          })
          (mkMachine {
            hostname = "work";
            nixModules = [
              ./nixos/wsl.nix
              ./nixos/tmpfsTmp.nix
            ];
          })
          (mkMachine {
            hostname = "riscy";
            nixModules = [
              ./nixos/run0.nix
              ./nixos/bootloader.nix
              ./nixos/security.nix
              ./nixos/sshd.nix
            ];
          })
          (mkMachine {
            hostname = "aurora";
            hmModules = [
              ./home-manager/alacritty.nix
              ./home-manager/gui.nix
              ./home-manager/niri.nix
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
              ./nixos/niri.nix
            ];
          })
        ])
      );
    };
}
