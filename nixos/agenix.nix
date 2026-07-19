{ inputs, config, ... }:
{
  imports = [
    "${inputs.agenix}/modules/age.nix"
  ];

  # I don't want bash junk handling my secrets thx
  nixpkgs.overlays = [
    (final: _: {
      agenix = final.ragenix;
    })
  ];
}
