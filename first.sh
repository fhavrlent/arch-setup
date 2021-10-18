#!/bin/bash

# Update system clock
timedatectl set-ntp true

# Create 1 EFI system partition and 1 LVM partition on nvme0n1

nvme format -s1 /dev/nvme0n1
nvme format -s1 /dev/nvme1n1
fdisk /dev/nvme0n1 <<EEOF
g
n


+512M
t
1
n



t

30
w
EEOF


# Create 1 LVM partition on nvme1n1
fdisk /dev/nvme1n1 <<EEOF
g
n



t
w
EEOF


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
mkdir /mnt/home
mkdir /mnt/boot
mount /dev/vol1/root /mnt
mount /dev/vol2/root /mnt/home
mount /dev/nvme0n1p1

genfstab -U /mnt >> /mnt/etc/fstab

pacstrap -i /mnt base base-devel linux linux-headers linux-lts linux-lts-headers linux-firmware lvm2 nano wget

arch-chroot /mnt
