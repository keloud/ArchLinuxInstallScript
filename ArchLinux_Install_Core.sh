#!/usr/bin/env bash
loadkeys jp106

##Setup Partition
fdsik /dev/sda <<EOS
g
n
1

+512M
t
1
n
2

+4G
t
2
19
n



w
EOS

mkfs.vfat -F32 /dev/sda1
mkswap /dev/sda2
mkfs.ext4 /dev/sda3
mount /dev/sda3 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
swapon dev/sda2

##Setup Time
timedatectl set-ntp true

#mirrorlist
grep -i ac.jp /etc/pacman.d/mirrorlist > mirrorlist
grep -i ad.jp /etc/pacman.d/mirrorlist >> mirrorlist
cat /etc/pacman.d/mirrorlist >> mirrorlist
cp mirrorlist /etc/pacman.d/mirrorlist

##Core Install
pacman -Syu --noconfirm
pacstrap /mnt base base-devel
genfstab -U /mnt >> /mnt/etc/fstab

##Next Script
echo echo -e "\033[0;33mNext Step\033[0;39m"
wget -O https://raw.githubusercontent.com/keloud/ArchLinux_InstallScript/master/ArchLinux_Install_Sub.sh
chmod 7 Install_Sub.sh
mv -f ./Install_Sub.sh /mnt/
arch-chroot /mnt /bin/bash /Install_Sub.sh