{
  services.zfs = {
    trim.enable = true;
    autoScrub.enable = true;
  };
  boot.zfs.forceImportRoot = false;
}
