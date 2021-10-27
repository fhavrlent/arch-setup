# Arch linux install script

This script is specific for my HW setup. Do not use it without editing it to suit your needs.
Manual steps
```
# Update system clock
timedatectl set-ntp true
```
1. Create 1 EFI system partition and 1 LVM partition on nvme0n1
2. Create 1 LVM partition on nvme1n1


First run
```
bash -c "`curl -L https://git.io/JKbxQ`"
```

Then run
```
bash -c "`curl -L https://git.io/JKNvZ`"
``` 

Pacman package list. 
```
wget https://git.io/Jidrk -O pacman-list.pkg
sudo pacman -S --needed - < pacman-list.pkg
```

AUR package list. 
```
wget https://git.io/Jidwy -O aur-list.pkg
yay -S --needed --noconfirm - < aur-list.pkg
```

[Dotfiles](https://github.com/fhavrlent/dotfiles)
```
chezmoi init --apply --verbose fhavrlent
```