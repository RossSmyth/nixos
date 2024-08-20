{
  pkgs,
  lib,
  inputs,
  ...
}: {
  programs.helix = {
    enable = true;
    defaultEditor = true;
    package = inputs.helix.packages.${pkgs.system}.default;
    settings = {
      theme = "bogsher";

      editor = {
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
        modifiers = ["bold"];
      };
    };
  };
}
