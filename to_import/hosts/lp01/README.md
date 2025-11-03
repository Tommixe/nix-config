# Dedicated disk in which install nixos
DISK=/dev/nvme0n1 
# "$DISK"pX (i.e. /dev/nvme0n1p5, /dev/nvme0n1p6) the partion number X in the disk


# Only for dedicated new disk

parted "$DISK" -- mklabel gpt
parted "$DISK" -- mkpart ESP fat32 1MiB 1GiB
parted "$DISK" -- set 1 boot on  
mkfs.vfat -n BOOT "$DISK"p1 #in a new disk fully dedicated the partition should be the number 1 

parted "$DISK" -- mkpart primary 1GiB 100%

### For installation alongside Windows 
1. Using Disk partitioning tool in Windows, shrink the existing Windows main partition to create not allocated space where install nixos.
2. In BIOS disable secureboot, save and exit.
3. Boot on a USB drive flashed with nixos iso downloaded from nixos.org
4. Stop the guided nixos installation
5. Using Gparted, in the not allocated space on the DISK create a new partion with size 1GiB, vfat32, label BOOT
To avoid the error about partition type set the partition type to xbootldr (number 136) using fdisk:
https://wiki.gentoo.org/wiki/Systemd/systemd-boot https://unix.stackexchange.com/questions/508890/how-to-change-partition-type-id-without-formatting
In the following the boot partition is "$DISK"p5 i.e. /dev/nvme0n1p5
6. Create a new primary partition on the remaining not allocated space, tha partion must not be formatted.
In the following the new primary partition is "$DISK"p6 i.e. /dev/nvme0n1p6
Set the partition name as the hostname
sudo cryptsetup config /dev/sdb1 --label YOURLABEL


#xxx Luks setup
cryptsetup --verify-passphrase -v luksFormat "$DISK"p6 
cryptsetup open "$DISK"p6 enc


#Create volume group inside the encrypted partition
pvcreate /dev/mapper/enc
vgcreate lvm /dev/mapper/enc

#Create the swap inside the encrypted partition
lvcreate --size 32G --name swap lvm   
lvcreate --extents 100%FREE --name root lvm
mkswap /dev/lvm/swap

#Create btrfs partition
mkfs.btrfs /dev/lvm/root

swapon /dev/lvm/swap

#Then create subvolumes
mount -t btrfs /dev/lvm/root /mnt
#We first create the subvolume
btrfs subvolume create /mnt/root  
btrfs subvolume create /mnt/nix   
btrfs subvolume create /mnt/persist 
#We then take an empty readonly snapshot of the root subvolume,
#which we'll eventually rollback to on every boot.
btrfs subvolume snapshot -r /mnt/root /mnt/root-blank

umount /mnt

#Mount the directories

mount -o subvol=root,compress=zstd,noatime /dev/lvm/root /mnt

mkdir /mnt/nix
mount -o subvol=nix,compress=zstd,noatime /dev/lvm/root /mnt/nix

mkdir /mnt/persist
mount -o subvol=persist,compress=zstd,noatime /dev/lvm/root /mnt/persist

#don't forget this!
mkdir /mnt/boot
mount nvme0n1p5 /mnt/boot

#if the installation is alongside windows and you plan to use xbootldr
#Use lsblk -f to finde the UUID of windows efi partiion
mkdir /mnt/efi  
mount /dev/disk/by-uuid/86BF-F822 /mnt/efi

# Generate create configurations
nixos-generate-config --root /mnt

# Edit the generated configuration files that are created in /mnt/etc/nixos folder
# 1. update hardware nix file to mount windows efi partition. Add:
 
 fileSystems."/efi" =
    { device = "/dev/disk/by-uuid/86BF-F822";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
# 2. Use the systemd-boot EFI boot loader, xbootldr and luks

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.consoleMode = "auto";
  boot.loader.systemd-boot.xbootldrMountPoint = "/boot";

  boot.loader.timeout = 5;
  
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/efi";

  boot.initrd.luks.devices = {
      enc = {
        # Use https://nixos.wiki/wiki/Full_Disk_Encryption
        device = "/dev/disk/by-uuid/34c8895b-50a7-476e-8fff-c897238d5720";
        preLVM = true;
      };
  }; 
# 3. Define user
# Define a user account. Don't forget to set a password with ‘passwd’
  users.users.yourname = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    hashedPassword = "Run mkpasswd -m sha-512 to generate it";
  };

# Finally 
nixos-install
reboot

