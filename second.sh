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
echo "default arc
timeout 3
editor 0" >> /boot/loader/loader.conf

echo "title Arch Linux
linux /vmlinuz-linux-lts
initrd /initramfs-linux-lts.img
options root=/dev/vol1/root quiet rw" > /boot/loader/entries/arch.conf

echo "Enter root password"
read ROOT_PSWD
passwd $ROOT_PSWD

echo "Enter username"
read USRNAME
useradd -m -g users -G wheel $USRNAME
echo "Enter password"
read PASSWD
passwd $PASSWD

echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers


dd if=/dev/zero of=/swapfile bs=1M count=SIZE status=progress
chmod 600 /swapfile
mkswap /swapfile
cp /etc/fstab /etc/fstab.bak
echo "swapfile none swap sw 0 0" | tee -a /etc/fstab
swapon -a

pacman -S amd-ucode nvidia nvidia-lts xorg

echo "
umount /mnt
reboot
"

exit