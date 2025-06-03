{ pkgs, inputs, ... }:
let
  latestNightly = pkgs.rust-bin.nightly.latest.minimal;
  rustPlatform = pkgs.makeRustPlatform {
    rustc = latestNightly;
    cargo = latestNightly;
    stdenv = pkgs.clangStdenv;
  };
  package = (pkgs.fd.override { inherit rustPlatform; }).overrideAttrs {
    src = inputs.fd;
    cargoDeps = rustPlatform.importCargoLock {
      lockFile = "${inputs.fd}/Cargo.lock";
      allowBuiltinFetchGit = true;
    };
    cargoHash = null;
    env.RUSTFLAGS = "-Ctarget-cpu=native -Cpanic=abort -Clto=thin -Cembed-bitcode=yes";
    doCheck = false;
  };
in
{
  programs.fd = {
    inherit package;
    enable = true;
  };
}
