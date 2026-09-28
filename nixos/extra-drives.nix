{ config, lib, pkgs, modulesPath, ... }:

{
  fileSystems = {
    "/var/sync" = {
      device = "/dev/disk/by-uuid/B0E4D354E4D31B82";
      fsType = "ntfs3";
      options = [ "uid=1000" "gid=1002" "dmask=0007" "fmask=0117" ];
    };
    "/opt/comsol" = {
      device = "/dev/disk/by-uuid/8b494eef-921c-4743-8f71-79839fa39c36";
      fsType = "btrfs";
      options = [ "subvol=/@comsol" "compress=zstd" ];
    };
    "/opt/games" = {
      device = "/dev/disk/by-uuid/8b494eef-921c-4743-8f71-79839fa39c36";
      fsType = "btrfs";
      options = [ "subvol=/@games" "compress=zstd" ];
    };
    "/var/lib/libvirt-sync" = {
      device = "/dev/disk/by-uuid/8b494eef-921c-4743-8f71-79839fa39c36";
      fsType = "btrfs";
      options = [ "subvol=/@libvirt" "compress=zstd" ];
    };
  };
}
