{ pkgs, inputs, ... }:
let
  latestNightly = (inputs.rust-overlay.lib.mkRustBin { } pkgs).nightly.latest.minimal;
  rustPlatform = pkgs.makeRustPlatform {
    rustc = latestNightly;
    cargo = latestNightly;
    stdenv = pkgs.clangStdenv;
  };
  package = (pkgs.bat.override { inherit rustPlatform; }).overrideAttrs {
    src = inputs.bat;
    cargoDeps = rustPlatform.importCargoLock {
      lockFile = "${inputs.bat}/Cargo.lock";
      allowBuiltinFetchGit = true;
    };
    cargoHash = null;
    env.RUSTFLAGS = "-Ctarget-cpu=native -Cpanic=abort -Clto=thin -Cembed-bitcode=yes";
    doCheck = false;
  };
in
{
  programs.bat = {
    inherit package;
    enable = true;
  };
}
