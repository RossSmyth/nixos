{ pkgs, inputs, ... }:
let
  latestNightly = (inputs.rust-overlay.lib.mkRustBin { } pkgs).nightly.latest.default;
  rustPlatform = pkgs.makeRustPlatform {
    rustc = latestNightly;
    cargo = latestNightly;
    stdenv = pkgs.clangStdenv;
  };
  package = (pkgs.ripgrep.override { inherit rustPlatform; }).overrideAttrs {
    src = inputs.ripgrep;
    cargoDeps = rustPlatform.importCargoLock {
      lockFile = "${inputs.ripgrep}/Cargo.lock";
      allowBuiltinFetchGit = true;
    };
    cargoHash = null;
    env.RUSTFLAGS = "-Ctarget-cpu=native -Cpanic=abort -Clto=thin -Cembed-bitcode=yes";
    doCheck = false;
  };
in
{
  programs.ripgrep = {
    inherit package;
    enable = true;
  };
}
