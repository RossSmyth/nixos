inputs:
{
  hostname,
  target ? "x86_64-linux",
  nixModules ? [ ],
  hmModules ? [ ],
  user ? "rsmyth",
}:
inputs.nixpkgs.lib.nixosSystem {
  system = target;
  specialArgs = {
    inherit inputs hostname user;
  };
  modules = [
    ./nixos
    ./${hostname}
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${user} = import ./home-manager;
      home-manager.extraSpecialArgs = {
        inherit inputs hostname user;
        extraModules = hmModules;
      };
    }
  ] ++ nixModules;
}
