!#bin/sh

loadkeys jp106

gdisk /dev/sda <<EOS
o
Y
n


+512MB
ef00
n




W
Y
EOS
mkfs.ext4 /dev/sda2
mount /dev/sda2 /mnt
mkdir /mnt/boot
mkfs.vfat -F32 /dev/sda1
mount /dev/sda1 /mnt/boot

##Setup Time
timedatectl set-ntp true

#mirrorlist
grep -i jp /etc/pacman.d/mirrorlist > mirrorlist
cat /etc/pacman.d/mirrorlist >> mirrorlist
cp mirrorlist /etc/pacman.d/mirrorlist

##Core Install
pacstrap /mnt base base-devel
genfstab -U -p /mnt >> /mnt/etc/fstab

##Next Script
echo echo -e "\033[0;33mNext Step\033[0;39m"
wget -O https://github.com/keloud/MyLinuxScripts/blob/master/ArchLinux_Install/ArchLinux_Install_Sub.sh
chmod 7 Install_Sub.sh
mv -f ./Install_Sub.sh /mnt/
arch-chroot /mnt /Install_Sub.sh