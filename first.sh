#!/bin/bash

# Format partition nvme0n1p1 to FAT32
mkfs.fat -F32 /dev/nvme0n1p1

# LVM setup
pvcreate -dataalignment 1m /dev/nvme0n1p2
pvcreate -dataalignment 1m /dev/nvme1n1p1

vgcreate vol1 /dev/nvme0n1p2
vgcreate vol2 /dev/nvme1n1p1

lvcreate -l 100%FREE vol1 -n root
lvcreate -l 100%FREE vol2 -n home

modprobe dm_mod
vgscan
vgchange -ay

mkfs.ext4 /dev/vol1/root
mkfs.ext4 /dev/vol2/home

# Mount partitions
mount /dev/vol1/root /mnt
mkdir /mnt/home
mount /dev/vol2/home /mnt/home
mkdir /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot

pacstrap -i /mnt base base-devel linux linux-headers linux-lts linux-lts-headers linux-firmware lvm2 nano wget

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt
