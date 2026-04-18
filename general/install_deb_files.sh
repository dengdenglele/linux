#!/bin/bash
echo "install updates" && sudo apt update && sudo apt upgrade -y

# NOTE
# some applications installed via apt might not be the up to date
# when using Debian, it might be better to install apps via flatpak (via flathub repro) for bleeding edge experience
# applications provided via apt might be better suited for stability instead of newest feature sets

# art and photography
sudo apt install darktable -y
sudo apt install gimp -y
sudo apt install inkscape -y
sudo apt install krita -y

# communication
sudo apt install telegram-desktop -y
sudo apt install thunderbird -y

# development
sudo apt install git -y
sudo apt install gitk -y
sudo apt install scratch -y
sudo apt install vim -y

# multimedia
sudo apt install ardour -y
sudo apt install audacity -y
sudo apt install handbrake -y
sudo apt install mixxx -y
sudo apt install obs-studio -y
sudo apt install vlc -y
sudo apt install shotcut -y

# office
sudo apt install abiword -y
sudo apt install gnumeric -y
sudo apt install libreoffice -y
sudo apt install ncal -y

# system
sudo apt install cups system-config-printer -y
sudo apt install cpu-x -y
sudo apt install gnome-shell-extension-manager -y
sudo apt install gnome-tweaks -y
sudo apt install gparted -y
sudo apt install htop -y	
sudo apt install i7z -y
sudo apt install intel-gpu-tools -y
sudo apt install kdiskmark -y
sudo apt install stress -y
sudo apt install tlp -y
sudo apt install ttf-mscorefonts-installer -y
sudo apt install vainfo -y
