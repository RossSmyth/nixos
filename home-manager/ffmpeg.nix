{ lib, pkgs, ... }:
let
  twoPass = pkgs.writers.writeBashBin "two-pass" {
    makeWrapperArgs = [
      "--prefix"
      "PATH"
      ":"
      (lib.makeBinPath [ pkgs.ffmpeg ])
    ];
  } ./ffmpeg/2pass.sh;

  audioNorm = pkgs.writers.writeBashBin "audio-norm" {
    makeWrapperArgs = [
      "--prefix"
      "PATH"
      ":"
      (lib.makeBinPath [
        pkgs.ffmpeg
        pkgs.jq
      ])
    ];
  } ./ffmpeg/audioNorm.sh;

  toMp3 = pkgs.writers.writeBashBin "to-mp3" {
    makeWrapperArgs = [
      "--prefix"
      "PATH"
      ":"
      (lib.makeBinPath [ pkgs.ffmpeg ])
    ];
  } ./ffmpeg/2mp3.sh;
in
{
  home.packages = [
    pkgs.ffmpeg
    twoPass
    audioNorm
    toMp3
  ];

}
