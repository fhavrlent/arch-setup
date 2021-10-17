
Verify internet connection
```
ping 1.1.1.1
```


Verify UEFI boot
```
ls /sys/firmware/efi/efivars
```

Update system clock
```
timedatectl set-ntp true
timedatectl status
```


Partidion disks, create partitions, format, generate Fstab
```
fdisk -l
fdisk xyz
g - new partition table
n - new partition
+500M - EFI system partition
t - change type
type 1 - efi system
type 30 - linux lvm

mkfs.fat -F32 /dev/xyz
pvcreate -dataalignment 1m /dev/xyz
vgcreate volX /dev/xyz

lvcreate -L xGB volX -n root
lvcreate -l X%FREE volX -n home

modprobe dm_mod
vgscan
vgchange -ay

mkfs.ext4 /dev/volX/root
mkfs.ext4 /dev/volX/home


mkdir /mnt/home
mkdir /mnt/boot
mount /dev/volX/root /mnt
mount /dev/volX/root /mnt/home
mount /dev/fat32part

genfstab -U /mnt >> /mnt/etc/fstab
```

Install base packages, chroot into system
```
pacstrap -i /mnt base base-devel linux linux-headers linux-lts linux-lts-headers linux-firmware lvm2 nano 

arch-chroot /mnt
```

Time zone

```
ln -sf /usr/share/zoneinfo/Region/City /etc/localtime

hwclock --systohc

systemctl enable systemd-timesyncd
```

Localitzation
```
nano /etc/locale.gen # uncomment locales I need
locale-gen

nano /etc/locale.conf
LANG=en_US.UTF-8
```

Network config
```
nano /etc/hostname
----
myhostname
-------------------
nano /etc/hosts
----
127.0.0.1	localhost
::1		localhost
127.0.1.1	myhostname

```

Instlal network packages
```
pacman -S openssh networkmanager wpa_supplicant wireless_tools netctl dialog
```

Enable NetorkManager (or you wont have internet)
```
systemctl enable NetworkManager
```

I forgor 💀
```
nano /etc/mkinitcpio.conf


HOOKS="base udev autodetect modconf block lvm2 filesystems keyboard fsck"

mkinitcpio -p linux
mkinitcpio -p linux-lts
```

Bootloader stuff
```
bootctl --path=/boot/ install
--------------------
nano /boot/loader/loader.conf
----
default arch
timeout 3
editor 0
--------------------
nano /boot/loader/entries/arch.conf
----
title Arch Linux
linux /vmlinuz-linux-lts
initrd /initramfs-linux-lts.img
options root=/dev/vol1/root quiet rw
```

Add user
```
useradd -m -g users -G wheel user
passwd user
```

Allow sudo command
```
EDTOR=nano visudo

%wheel ALL=(ALL) ALL
```

Swap file
```
dd if=/dev/zero of=/swapfile bs=1M count=SIZE status=progress
chmod 600 /swapfile
mkswap /swapfile
cp /etc/fstab /etc/fstab.bak
echo "swapfile none swap sw 0 0" | tee -a /etc/fstab
swapon -a
```

Install cpu shit, drivers and X server
```
pacman -S amd-ucode nvidia nvidia-lts xorg
```


Install KDE / GNOME or whatever
```
KDE
----
sudo pacman -S firefox plasma-nm plasma-pa dolphin kdeplasma-addons
sudo systemctl enable sddm
--------------
Gnome
----
Don't 
--------------
XFCE
----
sudo pacman -S xfce4 xfce4-goodies
```

Finish
```
exit
umount /mnt
reboot
```

pray


Pacman package list. 
```
https://gist.github.com/fhavrlent/86d9bdf03b6502d2c367ed2cd3b8d6d7
```

AUR package list. 
```
https://gist.github.com/fhavrlent/80996cdc45cf6dc724de7f625f8c82f8
```

