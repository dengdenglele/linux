# [Removing Snapd from Ubuntu](https://linuxconfig.org/uninstalling-snapd-on-ubuntu)

**WARNING:** Firefox snap version will be uninstalled with the following commands.
Be sure to install Firefox from the official Mozilla apt repo.

Remove all snaps, including the daemon, and make changes persistent
```bash
# list all snaps
snap list

# some snaps are dependent on other snaps, snap will tell you which shall be removed first
## first, remove all packages with Notes "-"
sudo snap remove --purge firefox
sudo snap remove --purge firmware-updater
sudo snap remove --purge gnome-3-38-2004
sudo snap remove --purge gnome-42-2204
sudo snap remove --purge gtk-common-themes
sudo snap remove --purge snap-store
sudo snap remove --purge snapd-desktop-integration
sudo snap remove --purge thunderbird

## second, remove all packages with Notes "base"
sudo snap remove --purge bare
sudo snap remove --purge core20
sudo snap remove --purge core22

## last, remove all packages with Notes "snapd"
sudo snap remove --purge snapd

# remove the snapd package itself, including configuration files
sudo apt purge snapd -y
sudo apt remove --purge gnome-software-plugin-snap
#sudo apt autoremove --purge snapd gnome-software-plugin-snap

# remove residual directories
rm -rf ~/snap
sudo rm -rf /snap
sudo rm -rf /var/snap
sudo rm -rf /var/lib/snapd
sudo rm -rf /var/cache/snapd/

# prevent snapd to be installed again
sudo apt-mark hold snapd

# prevent Ubuntu from automatically reinstalling snapd in the future
cat <<EOF | sudo tee /etc/apt/preferences.d/nosnap.pref
# To prevent repository packages from triggering the installation of Snap,
# this file forbids snapd from being installed by APT.
# For more information: https://linuxmint-user-guide.readthedocs.io/en/latest/snap.html

Package: snapd
Pin: release a=*
Pin-Priority: -10
EOF
```

Reboot system
```bash
sudo reboot
```

Optional steps
```bash
# verify that, snap will not get automatically reinstalled again via apt
# should fail to install: "E: Unable to correct problems, you have held broken packages"
sudo apt-get install chromium-browser
sudo apt install thunderbird

# install gnome-software as GUI app store WITHOUT snap plugin
sudo apt install gnome-software --no-install-recommends
```

Revert changes and make snap available again.
It is important to first remove nosnap.pref before unholding snapd
```bash
# optional: allow snapd to be installed again automatically
sudo rm /etc/apt/preferences.d/nosnap.pref
sudo apt-mark unhold snapd
sudo apt install snapd
```

**References**
- [prevent snapd to be installed automatically again via apt](https://askubuntu.com/questions/1035915/how-to-remove-snap-from-ubuntu)
- [create special configuration file for APT, as LinuxMint did to prevent future snap installations](https://askubuntu.com/questions/1345385/how-can-i-stop-apt-from-installing-snap-packages/1345401#1345401)
- [Chapter 19. Here Documents](https://tldp.org/LDP/abs/html/here-docs.html)
- [How to Remove Snap Packages in Ubuntu Linux](https://www.debugpoint.com/remove-snap-ubuntu/)
- [Uninstalling Snapd on Ubuntu  ](https://linuxconfig.org/uninstalling-snapd-on-ubuntu)
- [Ubuntu reddit - How to remove Snap (TUTORIAL](https://www.reddit.com/r/Ubuntu/comments/rkvgdx/how_to_remove_snap_tutorial/)
