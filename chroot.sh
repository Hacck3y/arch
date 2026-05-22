#!/bin/bash
set -e

ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen

echo LANG=en_US.UTF-8 > /etc/locale.conf

echo arch > /etc/hostname

cat > /etc/hosts << EOF
127.0.0.1 localhost
::1 localhost
127.0.1.1 arch.localdomain arch
EOF

echo
echo "SET ROOT PASSWORD"
passwd

useradd -m -G wheel -s /bin/bash hackey

echo
echo "SET USER PASSWORD"
passwd hacckey

echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers

systemctl enable NetworkManager

grub-install /dev/nvme0n1
grub-mkconfig -o /boot/grub/grub.cfg

echo "[✓] Installed"