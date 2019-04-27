#!/bin/bash

# Create partitions
parted --script -a optimal /dev/sda -- \
    mklabel msdos \
    mkpart primary 0% 512MiB \
    mkpart primary 512MiB 924GiB \
    mkpart primary linux-swap 924GiB 100%

mkfs.ext4 -L boot /dev/sda1
parted /dev/sda -- set 1 boot on

# Create swap partition
mkswap -L swap /dev/sda3

# Create LVM and root partition
pvcreate /dev/sda2
vgcreate system-vg /dev/sda2

lvcreate -L 80GB -n root system-vg
lvcreate -L 750GB -n home system-vg

mkfs.ext4 -L nixos /dev/system-vg/root
mkfs.ext4 -L nixos-home /dev/system-vg/home

# Mount partition
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
mkdir -p /mnt/home
mount /dev/disk/by-label/nixos-home /mnt/home
swapon /dev/sda3

# Generate NixOS config
nixos-generate-config --root /mnt

echo
echo "If noting failed, run nixos-install"

