{
  hostname,
  lib,
  disks ? [ "/dev/sda" ],
  ...
}:
{
  disk = {
    vda = {
      type = "disk";
      device = "/dev/sda";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            priority = 1;
            label = "EFI";
            name = "ESP";
            #start = "1MiB";
            size = "1G";
            type = "EF00";
            #bootable = true;
            content = {
              type = "filesystem";
              extraArgs = [ "-n EFI" ];
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          swap = {
            name = "swap";
            size = "100%";
            #start = "1GiB";
            #end = "6GiB";
            content = {
              type = "swap";
            };
          };
          server01 = {
            name = "${hostname}";
            label = "${hostname}";
            #start = "6GiB";
            #end = "15GiB";
            end = "-6G";
            #type = "primary";
            content = {
              type = "btrfs";
              extraArgs = [
                "-f"
                "--label  ${hostname}"
              ]; # Override existing partition
              #mountpoint = "/mnt";
              # Subvolumes must set a mountpoint in order to be mounted,
              # unless their parent is mounted
              subvolumes = {
                # Subvolume name is different from mountpoint
                "root" = {
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                  mountpoint = "/";
                };
                # Subvolume name is the same as the mountpoint
                /*
                  "home" = {
                    mountOptions = [ "compress=zstd" "noatime" ];
                    mountpoint = "/home";
                  };
                */
                # Sub(sub)volume doesn't need a mountpoint as its parent is mounted
                #"/home/user" = { };
                # Parent is not mounted so the mountpoint must be set
                "nix" = {
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                  mountpoint = "/nix";
                };
                "persist" = {
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                  mountpoint = "/persist";
                  #"neededForBoot" = "true";
                };
                /*
                  "log" = {
                    mountOptions = [ "compress=zstd" "noatime" ];
                    mountpoint = "/var/log";
                  };
                */
                # This subvolume will be created but not mounted
                #"/test" = { };
              };
              postCreateHook = "mount /dev/disk/by-partlabel/${hostname} /mnt \
                                  btrfs subvolume snapshot -r /mnt/root /mnt/root-blank \
                                  umount /mnt";
            };
          };
        };
      };
      # postMountHook = "btrfs subvolume snapshot -r /root /root-blank";
    };
  };
}
