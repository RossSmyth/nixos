{
  pkgs,
  lib,
  inputs,
  ...
}: {
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "bogster";

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
  };
}
