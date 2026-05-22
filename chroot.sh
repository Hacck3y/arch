#!/bin/bash
set -e

USERNAME="hacckey"

echo "[+] Time"

ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc

echo "[+] Locale"

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen

echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo arch > /etc/hostname

cat >/etc/hosts <<EOF
127.0.0.1 localhost
::1 localhost
127.0.1.1 arch.localdomain arch
EOF

echo
echo "ROOT PASSWORD"
passwd

useradd -m \
-G wheel,audio,video,storage,docker \
-s /bin/bash \
$USERNAME

echo
echo "USER PASSWORD"
passwd $USERNAME

echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers

echo "[+] Pacman"

pacman -Syu --noconfirm

echo "[+] BlackArch"

curl -O https://blackarch.org/strap.sh

chmod +x strap.sh

./strap.sh

pacman -Syy

pacman -S --noconfirm \
base-devel \
git \
curl \
wget \
nano \
vim \
openssh \
networkmanager \
ntfs-3g \
grub \
efibootmgr \
linux-headers \
firefox \
gnome \
gnome-extra \
gdm \
docker \
docker-compose \
kitty \
zsh \
obsidian \
keepassxc \
burpsuite \
nmap \
ffuf \
feroxbuster \
gobuster \
amass \
wireshark-qt \
john \
hashcat \
metasploit \
sqlmap \
seclists \
impacket \
rustscan \
docker

systemctl enable NetworkManager
systemctl enable gdm
systemctl enable docker

echo "[+] Brave"

pacman -S --needed --noconfirm git

cd /tmp

git clone https://aur.archlinux.org/yay.git
cd yay

sudo -u $USERNAME makepkg -si --noconfirm

sudo -u $USERNAME yay -S --noconfirm \
brave-bin \
caido-desktop \
subfinder \
httpx



echo "[+] Mount NTFS"

mkdir -p /run/media/$USERNAME/acer

cat >> /etc/fstab <<EOF

UUID=78B6F067B6F02772 \
/run/media/$USERNAME/acer \
ntfs-3g \
defaults,rw,uid=1000,gid=1000,umask=022 \
0 0

EOF

echo "[+] GRUB"

grub-install /dev/nvme0n1

grub-mkconfig -o /boot/grub/grub.cfg

echo
echo "[✓] COMPLETE"
echo
echo "reboot"