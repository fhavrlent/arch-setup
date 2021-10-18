# Arch linux install script

This script is specific for my HW setup. Do not use it without editing it to suit your needs.
Manual steps
```
# Update system clock
timedatectl set-ntp true

# Create 1 EFI system partition and 1 LVM partition on nvme0n1


fdisk /dev/nvme0n1
g
n


+512M
t
1
n



t

30
w


# Create 1 LVM partition on nvme1n1
fdisk /dev/nvme1n1
g
n



t
w

```

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
https://gist.github.com/fhavrlent/86d9bdf03b6502d2c367ed2cd3b8d6d7
```

AUR package list. 
```
https://gist.github.com/fhavrlent/80996cdc45cf6dc724de7f625f8c82f8
```

