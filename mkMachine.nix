inputs:
{
  hostname,
  target ? "x86_64-linux",
  nixModules ? [ ],
  hmModules ? [ ],
  user ? "rsmyth",
  local ? true,
  deployment ? { },
  fromSource ? true,
}:
{
  ${hostname} = {
    nixpkgs.system = target;

    deployment = deployment // {
      allowLocalDeployment = local;
      targetHost = if local then null else hostname;
    };

    imports = [
      ./nixos
      ./machines/${hostname}
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
  };
}
