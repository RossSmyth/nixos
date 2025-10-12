inputs:
{
  hostname,
  target ? "x86_64-linux",
  build ? "x86_64-linux",
  nixModules ? [ ],
  hmModules ? [ ],
  user ? "rsmyth",
  fromSource ? true,
}:
inputs.nixpkgs.lib.nixosSystem {
  system = target;
  specialArgs = {
    inherit inputs hostname user;
  };
  modules = [
    ./nixos
    ./machines/${hostname}
    {
      nixpkgs.buildPlatform = build;
      nixpkgs.hostPlatform = target;
    }
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${user} = import ./home-manager hmModules;
      home-manager.extraSpecialArgs = {
        inherit
          inputs
          hostname
          user
          fromSource
          ;
      };
    }
  ]
  ++ nixModules;
}
