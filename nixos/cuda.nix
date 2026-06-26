{
  lib,
  inputs,
  config,
  ...
}:
{
  nix.settings = {
    substituters = [
      "https://cache.nixos-cuda.org"
      "https://cache.flox.dev"
    ];
    trusted-public-keys = [
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs="
    ];
  };

  nixpkgs.pkgs = lib.mkForce (
    import inputs.cuda-nixpkgs {
      config = {
        cudaSupport = true;
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
      overlays = [
        (_: prev: {
          comma = prev.comma.override {
            nix = config.nix.package;
          };
        })
      ];
    }
  );
}
