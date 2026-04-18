# fedora-setup
let's start rolling with fedora

## Delete all partitions on a drive during live session with terminal
```bash
wipefs -a /dev/sdX

# if device is mounted, unmount it
umount /dev/sda1
```
- [Deleting All Partitions From the Command Line](https://serverfault.com/questions/250839/deleting-all-partitions-from-the-command-line)

## Video tutorial for Fedora installation
- [Tutorial: Fedora Workstation installieren (und dazu Windows partitionieren)](https://www.youtube.com/watch?v=cRIeogbzET4&t=1010s)
- Keyboard bug in installer
  - Even when selecting German layout, English qwerty layout is still being used
  - Be careful when setting passphrase for encryption blindly
- Select third party software after first reboot after installation
- First tutorial after finishing user and passord is about GNOME features (overview explanation, touchpad swiping)
- Also add rpm fusion packages
## Update BIOS (and other firmware) with terminal

```bash
fwupdmgr get-updates ; fwupdmgr update
```
- [I want to update BIOS in a complete Linux(Fedora Workstation 36) environment](https://www.reddit.com/r/Fedora/comments/yot62i/i_want_to_update_bios_in_a_complete_linuxfedora/)

## Problematic flatpak version of Signal
Flatpak installation of Signal with security warning:

```bash
Signal is being launched with the plaintext password store by
default due to database corruption bugs when using the encrypted backends.
This will leave your keys unencrypted on disk as it did in all previous versions.

If you wish to experiment with the encrypted backend, set the environment variable
SIGNAL_PASSWORD_STORE to gnome-libsecret, kwallet,
kwallet5 or kwallet6 depending on your desktop environment using
Flatseal or the following command:

flatpak override --env=SIGNAL_PASSWORD_STORE=gnome-libsecret org.signal.Signal

Note that the encrypted backends are experimental and may cause data loss on some systems.

Press Yes to proceed with plaintext password store or
No to exit.
```

Recommended installation method is via additional repo

```bash
user@fedora:~$ sudo dnf config-manager addrepo --from-repofile=https://download.opensuse.org/repositories/network:im:signal/Fedora_41/network:im:signal.repo
user@fedora:~$ sudo dnf install signal-desktop
```

- [Accurate way to install signal in fedora](https://discussion.fedoraproject.org/t/accurate-way-to-install-signal-in-fedora/117236)
- [Does anyone know what's up with Signal on Fedora currently?](https://www.reddit.com/r/Fedora/comments/1fsrzyi/does_anyone_know_whats_up_with_signal_on_fedora/)
- [Signal under fire for storing encryption keys in plaintext](https://news.ycombinator.com/item?id=40898353)

## Different flatpak remotes available for OBS Studio installation
There are two flatpak remotes available for OBS installation ('fedora' and 'flathub')

Main differences:
- 'fedora'
  - Newest version
  - Does not install additional packages for hardware encoding, only OpenH264 available as software encoder
  - Hardware encoding might be fixed/added with addition of rpm packages?
- 'flathub'
  - Slightly older version
  - Ships with relevant packages for hardware encoding
  - HEVC and H.264 can be selected with harddware acceleration e.g. Intel Quick Sync
  - Hardware acceleration can be observed with intel_gpu_top
 
## Add free and nonfree RPM fusion repositories

```bash
# enable rpm fusion free repository
sudo dnf install \
https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
# enable rpm fusion nonfree repository
sudo dnf install \
https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
```

- [Enabling the RPM Fusion repositories](https://docs.fedoraproject.org/en-US/quick-docs/rpmfusion-setup/)
- [Installing Free and Nonfree Repositories](https://rpmfusion.org/Configuration)
- [Verify RMP Fusion keys](https://rpmfusion.org/keys)

## Enable hardware acceleration on Intel hardware

RPM fusion repositories are a mandatory requirement

```bash
# verify current state
sudo dnf install vainfo
vainfo > ~/vainfo-before-intel-driver-installation.md

# install
sudo dnf install ffmpeg-free ### From repository : anaconda
sudo dnf install libavcodec-freeworld ### From repository : rpmfusion-free
sudo dnf install intel-media-driver ### From repository : rpmfusion-nonfree

# for older Intel GPUs use libva-intel-driver
# sudo dnf install libva-intel-driver ### Repository : rpmfusion-free

# verify again
vainfo > ~/vainfo-after-intel-driver-installation.md
diff vainfo-before-intel-driver-installation.md vainfo-after-intel-driver-installation.md

# verify with intel-gpu-tools
sudo dnf install igt-gpu-tools
sudo intel_gpu_top
```

- [Configure VA-API Video decoding on Intel](https://fedoraproject.org/wiki/Firefox_Hardware_acceleration#Configure_VA-API_Video_decoding_on_Intel)
- [Arch Wiki: Hardware video acceleration](https://wiki.archlinux.org/title/Hardware_video_acceleration)

## Add multimedia plugins

```bash
# only for Fedora 41 and newer
sudo dnf group install multimedia
```

- [Installing plugins for playing movies and music](https://docs.fedoraproject.org/en-US/quick-docs/installing-plugins-for-playing-movies-and-music/)
- Inside "Software" App > "Explore" > go to bottom to "Other Categories > Codecs" to view all currently installed codecs

## Increase font size in foot terminal emulator
```
mkdir ~/.config/foot
cp /etc/xdg/foot/foot.ini ~/.config/foot
sed -i '/# font=monospace:size=8/a font=monospace:size=12' ~/.config/foot/foot.ini
```

- [Increase font size in terminal (sway)](https://forum.manjaro.org/t/increase-font-size-in-terminal/125392)

## Add GNOME to Fedora spin (e.g. Fedora sway)
```
sudo dnf update
sudo dnf install @gnome-desktop
sudo reboot
```

- [How to Install and Switch Desktop Environments in Fedora](https://www.tecmint.com/install-and-switch-desktop-environments-in-fedora/)

## Enable Fedora web console (dashboard with CLI)
```
sudo systemctl enable --now cockpit.socket
```
- Can be accessed in any browser
  - https://\<hostname>:9090/ OR
  - https://\<host-IP>:9090/
### Disable web console
```
sudo systemctl stop cockpit.socket
sudo systemctl disable cockpit.socket
```
