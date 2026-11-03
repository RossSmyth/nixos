{ inputs, config, ... }:
{
  imports = [
    "${inputs.agenix}/modules/age.nix"
  ];

  age.identityPaths = builtins.catAttrs "path" config.services.openssh.hostKeys;

  # I don't want bash junk handling my secrets thx
  nixpkgs.overlays = [
    (final: _: {
      agenix = final.ragenix;
    })
  ];
}
