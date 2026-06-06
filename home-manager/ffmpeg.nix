{ lib, pkgs, ... }:
let
  twoPass = pkgs.writers.writeBash "two-pass" {
    makeWrapperArgs = [
      "--prefix"
      "PATH"
      ":"
      (lib.makeBinPath [ pkgs.ffmpeg ])
    ];
  } ./ffmpeg/2pass.sh;

  audioNorm = pkgs.writers.writeBash "audio-norm" {
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

  toMp3 = pkgs.writers.writeBash "to-mp3" {
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
