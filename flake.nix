{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    helix.url = "github:helix-editor/helix";
  };

  outputs = {
    self,
    nixpkgs,
    nixos-wsl,
    home-manager,
    ...
  } @ inputs: let
    machine = {
      hostname,
      target ? "x86_64-linux",
      extraModules ? [],
    }:
      nixpkgs.lib.nixosSystem {
        system = target;
        specialArgs = {inherit inputs;};
        modules =
          [
            ./common.nix
            ./${hostname}/hardware-configuration.nix
            ./${hostname}/system.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.rsmyth = import ./home-manager/home.nix;
              home-manager.extraSpecialArgs = {inherit inputs;};
            }
          ]
          ++ extraModules;
      };
  in {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
    nixosConfigurations = {
      desktop = machine {
        hostname = "desktop";
      };
    };
  };
}
