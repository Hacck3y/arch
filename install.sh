#!/bin/bash
set -e

lsblk -f    

BOOT="/dev/nvme0n1p5"
SWAP="/dev/nvme0n1p6"
ROOT="/dev/nvme0n1p7"

echo "[+] WARNING"
echo "This will ERASE:"
echo "$BOOT"
echo "$SWAP"
echo "$ROOT"

read -p "Type YES to continue: " c

[ "$c" = "YES" ] || exit 1

echo "[+] Unmounting..."

swapoff -a || true
umount -R /mnt 2>/dev/null || true

echo "[+] Formatting..."

mkfs.ext4 -F "$ROOT"
mkfs.ext4 -F "$BOOT"
mkswap "$SWAP"

echo "[+] Mounting..."

mount "$ROOT" /mnt

mkdir -p /mnt/boot
mount "$BOOT" /mnt/boot

swapon "$SWAP"

echo "[+] Installing base..."

pacstrap -K /mnt \
base \
linux \
linux-firmware \
base-devel \
sudo \
git \
nano \
vim \
grub \
networkmanager \
efibootmgr

echo "[+] Generating fstab..."

genfstab -U /mnt >> /mnt/etc/fstab

curl -fsSL \
https://raw.githubusercontent.com/hacck3y/arch/main/chroot.sh \
-o /mnt/chroot.sh

chmod +x /mnt/chroot.sh

arch-chroot /mnt /chroot.sh

echo
echo "[✓] Complete"
echo "reboot"