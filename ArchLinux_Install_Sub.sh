!#bin/sh
##Setup
echo -n "What is Host name? : "
read -r HOSTNAME
export HOSTNAME
echo -n "What is Root Password? : "
read -r ROOTPASSWD
export ROOTPASSWD
echo -n "What is User name? : "
read -r USERNAME
export USERNAME
echo -n "What is User Password? : "
read -r USERPASSWD
export USERPASSWD

sed -i -e 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
sed -i -e 's/#ja_JP.UTF-8 UTF-8/ja_JP.UTF-8 UTF-8/g' /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 >> /etc/locale.conf
export LANG=en_US.UTF-8
echo KEYMAP=jp106 >> /etc/vconsole.conf
ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
hwclock -u -w

##HostName Set
echo $HOSTNAME > /etc/hostname

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

echo "Install Light-DM and Gnome"

##Xorg
pacman -S --noconfirm xorg-server xorg-server-utils xorg-xinit xf86-video-fbdev mesa
pacman -S --noconfirm xf86-video-openchrome

##Light-DM Gnome
pacman -S --noconfirm lightdm lightdm-gtk-greeter

##Light-DM Deepin
#pacman -S --noconfirm lightdm lightdm-deepin-greeter
#sed -i -e "s/#greeter-session=/c\#greeter-session=lightdm-deepin-greeter/g" /etc/lightdm/lightdm.conf

##Light DM Setup
sed -i -e "s/#logind-check-graphical=false/#logind-check-graphical=true/g" /etc/lightdm/lightdm.conf
systemctl enable lightdm.service

##Deepin
#pacman -S --noconfirm deepin deepin-extra

##Gnome
pacman -S --noconfirm gnome gnome-extra gnome-initial-setup

##Other
pacman -S --noconfirm sudo

##Add User
useradd -m -g wheel $USERNAME
echo $USERNAME":"$USERPASSWD | chpasswd 

##End
echo -e "\033[0;33mProbably this processing was completed.\033[0;39m"
exit