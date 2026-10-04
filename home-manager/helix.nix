{
  lib,
  pkgs,
  inputs,
  ...
}:
let
  helix-src = pkgs.stdenvNoCC.mkDerivation {
    name = "helix-patched";
    src = inputs.helix;
    nativeBuildInputs = [ pkgs.dasel ];
    buildPhase = ''
      cat languages.toml | dasel -i toml --root 'grammar = grammar.filter($this.name != "perl")' > languages.toml.new
      mv languages.toml.new languages.toml

      mkdir -p "$out"
      cp -r . "$out"
    '';
  };
in
{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    package = pkgs.callPackage helix-src { gitRev = inputs.helix.revision; };
    settings = {
      theme = "bogsher";

      editor = {
        rainbow-brackets = true;
        true-color = true;
        line-number = "relative";
        mouse = false;
        cursorline = true;
        bufferline = "multiple";
        default-line-ending = "lf";
        cursor-shape.insert = "bar";
        cursor-shape.select = "underline";
        lsp.display-inlay-hints = true;
        lsp.display-messages = true;
        file-picker.hidden = false;
        file-picker.git-ignore = true;
      };
    };
    themes.bogsher = {
      inherits = "bogster";
      "variable" = "bogster-fg1";
      "variable.other.member" = "bogster-fg1";
      "variable.parameter" = "bogster-fg1";
      "identifier" = "bogster-fg1";
      "ui.virtual.inlay-hint" = "bogster-fg0";
      "ui.selection.bg" = "bogster-base3";
      "ui.selection.primary.bg" = "bogster-base4";
      "ui.virtual.jump-label" = {
        bg = "bogster-base3";
        modifiers = [ "bold" ];
      };
    };
  };
}
