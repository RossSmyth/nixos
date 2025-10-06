{
  lib,
  pkgs,
  inputs,
  fromSource,
  ...
}:
let
  # TODO: Remove at next ripgrep release
  package = pkgs.ripgrep.overrideAttrs {
    src = inputs.ripgrep;
    cargoDeps = pkgs.rustPlatform.importCargoLock {
      lockFile = "${inputs.ripgrep}/Cargo.lock";
      allowBuiltinFetchGit = true;
    };
    cargoHash = null;
    doCheck = false;
  };
in
{
  programs.ripgrep = {
    package = lib.mkIf fromSource package;
    enable = true;
  };
}
