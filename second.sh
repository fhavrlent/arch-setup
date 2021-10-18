#!/bin/bash
ln -sf /usr/share/zoneinfo/Europe/Bratislava /etc/localtime
hwclock --systohc

# Download locale file, generate locale
cd /etc/
rm locale.gen
wget https://raw.githubusercontent.com/fhavrlent/arch-setup/main/locale.gen
chmod 644 locale.gen
cd ~
locale-gen

echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo "home" > /etc/hostname

echo "# Static table lookup for hostnames.
# See hosts(5) for details.
127.0.0.1	localhost
::1		localhost
127.0.1.1	home" > /etc/hosts

pacman -Sy openssh networkmanager wpa_supplicant wireless_tools netctl dialog

systemctl enable NetworkManager

cd /etc/
rm mkinitcpio.conf
wget https://raw.githubusercontent.com/fhavrlent/arch-setup/main/mkinitcpio.conf
chmod 644 mkinitcpio.conf
cd ~

mkinitcpio -p linux
mkinitcpio -p linux-lts

bootctl --path=/boot/ install
echo "default arch
timeout 3
editor 0" >> /boot/loader/loader.conf

echo "title Arch Linux
linux /vmlinuz-linux
initrd /initramfs-linux.img
options root=/dev/vol1/root lsm=landlock,lockdown,yama,apparmor,bpf quiet rw" > /boot/loader/entries/arch.conf

passwd

echo "Enter username"
read USRNAME
useradd -m -g users -G wheel $USRNAME
passwd $USRNAME

echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

dd if=/dev/zero of=/swapfile bs=1M count=SIZE status=progress
chmod 600 /swapfile
mkswap /swapfile
cp /etc/fstab /etc/fstab.bak
echo "swapfile none swap sw 0 0" | tee -a /etc/fstab
swapon -a

pacman -S amd-ucode nvidia nvidia-lts xorg

echo "KDE[1], GNOME[2] or XFCE[3]"
read DESELECT
if [ "$DESELECT" -eq 1  ]; then
    pacman -S plasma-desktop sddm plasma-nm plasma-pa dolphin kdeplasma-addons plasma xdg-user-dirs packagekit-qt5
    systemctl enable sddm
    elif [ "$DESELECT" -eq 2 ]; then
    pacman -S gnome
    systemctl enable gdm.service
    elif [ "$DESELECT" -eq 3 ]; then
    pacman -S xfce4 xfce4-goodies lightdm lightdm-gtk-greeter
    systemctl enable lightdm
else
    echo "No DE selected"
fi

pacman -S firefox tilix
pacman -S pipewire pipewire-pulse pipewire-alsa pipewire-jack
pacman -S apparmor ufw gufw

echo "
umount /mnt
reboot
"

exit
