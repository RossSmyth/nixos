{
  # This needs to go somewhere else
  systemd.tmpfiles.settings."10-lib"."/media/lib".d = {
    mode = "2775";
    user = "librarian";
    group = "librarian";
  };

  users.users.librarian = {
    enable = true;
    group = "librarian";
    isSystemUser = true;
  };

  users.groups.librarian = { };
}
