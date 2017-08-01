#!/usr/bin/env bash
##Setup
echo -n "What is Host name? : "
read HNAME
echo -n "What is Root Password? : "
read -s ROOTPASSWD
echo -n "What is User name? : "
read USERNAME
echo -n "What is User Password? : "
read -s USERPASSWD

sed -i -e 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
sed -i -e 's/#ja_JP.UTF-8 UTF-8/ja_JP.UTF-8 UTF-8/g' /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 >> /etc/locale.conf
export LANG=en_US.UTF-8
echo KEYMAP=jp106 >> /etc/vconsole.conf
ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
hwclock -u -w

##HostName Set
echo $HNAME > /etc/hostname

##RootPassWord Set
echo "root:"$ROOTPASSWD | chpasswd

##pacman update
pacman -Syu

##grub setup
pacman -S --noconfirm grub dosfstools efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ArchLinux --recheck --debug
grub-mkconfig -o /boot/grub/grub.cfg

##NetworkManager
pacman -S --noconfirm networkmanager network-manaer-applet 
systemctl enable NetworkManager.service

##Add User
useradd -m -g wheel $USERNAME
echo $USERNAME":"$USERPASSWD | chpasswd 

##End
echo -e "\033[0;33mProbably this processing was completed.\033[0;39m"
exit