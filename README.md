```
ping 1.1.1.1
```

```
fdisk -l
fdisk xyz
g
n
+500M
t
1 - efi system
n
t
30 - linux lvm

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

genfstab -U -p /mnt >> /mnt/etc/fstab
```

```
pacstrap -i /mnt base base-devel linux linux-headers linux-lts linux-lts-headers linux-firmware lvm2 nano 
arch-chroot /mnt
```

```
pacman -S openssh networkmanager wpa_supplicant wireless_tools netctl dialog
```

```
systemctl enable NetworkManager
```

```
nano /etc/mkinitcpio.conf


HOOKS="base udev autodetect modconf block lvm2 filesystems keyboard fsck"

mkinitcpio -p linux
mkinitcpio -p linux-lts
```

```
bootctl --path=/boot/ install
nano /boot/loader/loader.conf

default arch
timeout 3
editor 0

nano /boot/loader/entries/arch.conf

title Arch Linux
linux /vmlinuz-linux-lts
initrd /initramfs-linux-lts.img
options root=/dev/vol1/root quiet rw
```

```
useradd -m -g users -G wheel user
passwd user
```
```
EDTOR=nano visudo

%wheel ALL=(ALL) ALL
```


```
dd if=/dev/zero of=/swapfile bs=1M count=SIZE status=progress
chmod 600 /swapfile
mkswap /swapfile
cp /etc/fstab /etc/fstab.bak
echo "swapfile none swap sw 0 0" | tee -a /etc/fstab
swapon -a
```

```
timedatectl set-timezone Europe/Bratislava
systemctl enable systemd-timesyncd
```

```
hostnamectl set-hostname home
nano /etc/hosts

127.0.0.1 localhost
::1 localhost
127.0.1.1 arch
```

```
pacman -S amd-ucode nvidia nvidia-lts xorg
```



Install KDE / GNOME or whatever

```
exit
umount /mnt
reboot
```

pray
