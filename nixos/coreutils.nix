{ pkgs, lib, ... }:
let
  latestNightly = pkgs.rust-bin.nightly.latest.minimal;
  rustPlatform = pkgs.makeRustPlatform {
    rustc = latestNightly;
    cargo = latestNightly;
    stdenv = pkgs.clangStdenv;
  };
  uutils = (pkgs.uutils-coreutils-noprefix.override {
    inherit rustPlatform;
  }).overrideAttrs {
    postPatch = ''
        substituteInPlace ./src/uu/uname/src/uname.rs \
          --replace-fail '(opts.os || opts.all).then(|| uname.osname().to_string_lossy().to_string())' 'Some(":3/Linux".to_string())'
      '';
    env.RUSTFLAGS = "-Ctarget-cpu=native";
    cargoBuildFlags = [
      "--config" "profile.release.lto=thin"
      "--config" "profile.release.panic=abort"
    ];
    doCheck = false;
  };
in
{
  # Replace coreutils with uutils
  # Need hiPrio or else there are collisions
  environment.systemPackages = [
    (lib.hiPrio uutils)
  ];
}
